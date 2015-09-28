require 'spec_helper'

describe 'named_interfaces' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "named_interfaces class without any parameters" do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('named_interfaces::config') }
        end
      end
    end
  end
end
