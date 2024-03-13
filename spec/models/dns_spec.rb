require 'rails_helper'

RSpec.describe Dns, type: :model do  
  describe 'validations' do
    it {  build(:dns, ip: nil).should_not be_valid }
    it {  build(:dns, ip: '1.1.1.1').should be_valid }
  end

  describe 'scopes' do
    describe 'by_hostnames' do
      let!(:dns1) { create(:dns, ip: '1.1.1.1') }
      let!(:dns2) { create(:dns, ip: '2.2.2.2') }
      let!(:dns3) { create(:dns, ip: '3.3.3.3') }
      
      before do
        hostname1 = create(:hostname, hostname: 'hostname1')
        hostname2 = create(:hostname, hostname: 'hostname1')
        hostname3 = create(:hostname, hostname: 'hostname1')
        hostname4 = create(:hostname, hostname: 'hostname2')
        hostname5 = create(:hostname, hostname: 'hostname2')
        hostname6 = create(:hostname, hostname: 'hostname3')
        
        create(:dns_hostname, dns: dns1, hostname: hostname1)
        create(:dns_hostname, dns: dns1, hostname: hostname2)

        create(:dns_hostname, dns: dns2, hostname: hostname3)
        create(:dns_hostname, dns: dns2, hostname: hostname4)

        create(:dns_hostname, dns: dns3, hostname: hostname5)
        create(:dns_hostname, dns: dns3, hostname: hostname6)
      end

      it 'returns dns records that have all the hostnames' do
        expect(Dns.by_hostnames(['hostname1', 'hostname2'])).to match_array([dns1, dns2])
      end
    end
  end
end
