require 'spec_helper'

describe 'nfsen' do

  describe 'nfsen with no parameters, basic test' do
    let (:params) { { } }

    it { should create_class('nfsen') }
  end
end
