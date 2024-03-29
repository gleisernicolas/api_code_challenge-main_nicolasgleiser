class Dns < ApplicationRecord
  DEFAULT_LIMIT = 10

  table_name = 'dns'
  
  has_many :dns_hostname
	has_many :hostnames, through: :dns_hostname

  scope :by_hostnames, ->(hostnames) { joins(:hostnames).where(hostnames: { hostname: hostnames }).group('dns.id').having('count(dns.id) = ?', hostnames.size) if hostnames.present? }

  scope :page, ->(page) { limit(DEFAULT_LIMIT).offset((page.to_i - 1) * DEFAULT_LIMIT) }

  validates :ip, presence: true, uniqueness: true
end