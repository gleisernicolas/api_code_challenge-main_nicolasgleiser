class Dns::Hostnames
  attr_reader :included, :excluded, :page

  def self.call(included, excluded, page)
    self.new(included, excluded, page).call
  end

  def initialize(included, excluded, page)
    @included = included
    @excluded = excluded
    @page = page
  end

  def call
    return { } if dns.empty?
    
    hostname_array = build_hostnames_response
    dns_array = build_dns_response

    { total_records: dns_array.count, records: dns_array, related_hostnames: hostname_array }
  end
  private

  attr_reader :dns, :hostnames

  def dns
    @dns ||= Dns.by_hostnames(@included).page(@page).uniq.delete_if { |dns| dns.hostnames.any? { |hostname| @excluded&.include?(hostname.hostname) } }
  end

  def hostnames
    @hostnames ||= Hostname.joins(:dns).where(dns: { id: dns.map(&:id) }).where.not(hostname: @included).order(:created_at).to_a
  end

  def grouped_hostnames
    hostnames.inject(Hash.new(0)) { |h, e| h[e.hostname] += 1 ; h }
  end

  def build_hostnames_response
    grouped_hostnames.map do |hostname, count|
      {
        count: count,
        hostname: hostname
      }
    end
  end

  def build_dns_response
    dns.map do |dns|
      {
        id: dns.id,
        ip_address: dns.ip
      }
    end
  end
end