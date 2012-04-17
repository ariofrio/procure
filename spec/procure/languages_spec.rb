require 'spec_helper'
require 'procure/languages'

describe Procure::Languages do
  subject { Procure::Languages }

  it "lists languages" do
    subject.to_a.length.should >= 1
  end
end