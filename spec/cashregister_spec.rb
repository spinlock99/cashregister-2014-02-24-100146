require 'spec_helper'
require 'cashregister'

describe Cashregister do
  describe "new" do
    it "should instantiate" do
      lambda {
        Cashregister.new
      }.should_not raise_exception
    end
  end
end
