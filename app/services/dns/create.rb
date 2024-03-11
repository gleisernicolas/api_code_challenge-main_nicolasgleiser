class Dns::Create
  attr_reader :params

  def self.call!(params)
    new(params).call!
  end

  def initialize(params)
    @params = params
  end

  def call!
    dns = Dns.create!(ip: params[:ip])
    hostnames = Hostname.create!(params[:hostnames_attributes])
    persist_hostnames!(hostnames, dns.id)
    dns.id
  end

  def persist_hostnames!(hostnames, dns_id)
    hostnames.each do |hostname|
      DnsHostname.create!(dns_id: dns_id, hostname_id: hostname.id)
    end
  end
end