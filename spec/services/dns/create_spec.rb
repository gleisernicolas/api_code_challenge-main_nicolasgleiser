require 'rails_helper'

RSpec.describe Dns::Create do
  describe '#call!' do
    let(:params) do
      {
        ip: '1.1.1.1',
        hostnames_attributes: [
          { hostname: 'example.com' },
          { hostname: 'example.org' }
        ]
      }
    end

    it 'creates a new dns record' do
      expect { described_class.call!(params) }.to change { Dns.count }.by(1)
    end

    it 'creates new hostnames' do
      expect { described_class.call!(params) }.to change { Hostname.count }.by(2)
    end
  end
end