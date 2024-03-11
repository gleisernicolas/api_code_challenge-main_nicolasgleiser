class Hostname < ApplicationRecord
  has_one :dns_hostname, class_name: 'DnsHostname'
  has_one :dns, through: :dns_hostname

  validates :hostname, presence: true
end