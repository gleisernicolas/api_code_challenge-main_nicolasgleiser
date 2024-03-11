class DnsHostname < ApplicationRecord
  belongs_to :hostname
  belongs_to :dns

  validates :hostname_id, presence: true
  validates :dns_id, presence: true
  validates :hostname_id, uniqueness: { scope: :dns_id }
end