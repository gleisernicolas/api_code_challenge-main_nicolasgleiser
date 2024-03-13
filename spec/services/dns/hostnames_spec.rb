require 'rails_helper'

RSpec.describe Dns::Hostnames do
  describe '#call!' do
    context 'with page' do
      context 'when page = 2' do
        subject { described_class.call(nil, nil, 2) }

        before { create_list(:dns, 12, :with_hostnames) }
        
        it 'return the correct total_records' do
          expect(subject[:total_records]).to eq(2)
        end
      end

      context 'when page = 1' do
        let!(:dns1) { create(:dns) }
        let!(:dns2) { create(:dns) }
        let!(:dns3) { create(:dns) }
        
        before do
          hostname1 = create(:hostname, hostname: 'hostname1')
          hostname2 = create(:hostname, hostname: 'hostname1')
          hostname3 = create(:hostname, hostname: 'hostname1')
          hostname4 = create(:hostname, hostname: 'hostname2')
          hostname5 = create(:hostname, hostname: 'hostname2')
          hostname6 = create(:hostname, hostname: 'hostname3')
          hostname7 = create(:hostname, hostname: 'hostname3')
          hostname8 = create(:hostname, hostname: 'hostname8')
          
          create(:dns_hostname, dns: dns1, hostname: hostname1)
          create(:dns_hostname, dns: dns1, hostname: hostname2)
          create(:dns_hostname, dns: dns1, hostname: hostname7)

          create(:dns_hostname, dns: dns2, hostname: hostname3)
          create(:dns_hostname, dns: dns2, hostname: hostname4)
          create(:dns_hostname, dns: dns2, hostname: hostname8)

          create(:dns_hostname, dns: dns3, hostname: hostname5)
          create(:dns_hostname, dns: dns3, hostname: hostname6)
        end

        context 'without included' do
          subject { described_class.call(nil, nil, 1) }

          it 'return the correct total_records' do
            expect(subject[:total_records]).to eq(3)
          end

          it 'return the correct records' do
            expect(subject[:records]).to match_array([
              { id: dns1.id, ip_address: dns1.ip },
              { id: dns2.id, ip_address: dns2.ip },
              { id: dns3.id, ip_address: dns3.ip }
            ])
          end

          it 'return the correct related_hostnames' do
            expect(subject[:related_hostnames]).to match_array([
              { count: 3, hostname: 'hostname1' },
              { count: 2, hostname: 'hostname2' },
              { count: 2, hostname: 'hostname3' },
              { count: 1, hostname: 'hostname8' }
            ])
          end

          context 'and excluded ["hostname1"]' do
            subject { described_class.call(nil, ['hostname1'], 1) }
            
            it 'return the correct total_records' do
              expect(subject[:total_records]).to eq(1)
            end

            it 'return the correct records' do
              expect(subject[:records]).to match_array([
                { id: dns3.id, ip_address: dns3.ip }
              ])
            end

            it 'return the correct related_hostnames' do
              expect(subject[:related_hostnames]).to match_array([
                { count: 1, hostname: 'hostname2' },
                { count: 1, hostname: 'hostname3' }
              ])
            end
          end
        end

        context 'with included ["hostname1", "hostname2"]' do
          subject { described_class.call(['hostname1', 'hostname2'], nil, 1) }
          
          it 'return the correct total_records' do
            expect(subject[:total_records]).to eq(2)
          end

          it 'return the correct records' do
            expect(subject[:records]).to match_array([
              { id: dns1.id, ip_address: dns1.ip },
              { id: dns2.id, ip_address: dns2.ip }
            ])
          end

          it 'return the correct related_hostnames' do
            expect(subject[:related_hostnames]).to match_array([
              { count: 1, hostname: 'hostname3' },
              { count: 1, hostname: 'hostname8'}
            ])
          end

          context 'and excluded ["hostname8"]' do
            subject { described_class.call(['hostname1', 'hostname2'], ['hostname8'], 1) }
            
            it 'return the correct total_records' do
              expect(subject[:total_records]).to eq(1)
            end

            it 'return the correct records' do
              expect(subject[:records]).to match_array([
                { id: dns1.id, ip_address: dns1.ip },
              ])
            end

            it 'return the correct related_hostnames' do
              expect(subject[:related_hostnames]).to match_array([
                { count: 1, hostname: 'hostname3' }
              ])
            end
          end
        end
      end
    end
  end
end


