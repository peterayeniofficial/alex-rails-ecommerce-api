require 'rails_helper'

RSpec.describe Publisher, type: :model do
  it { should validate_presence_of(:name) }
  it { should have_many(:books) }

  it 'has a valid factory' do
    expect(build(:publisher)).to be_valid
  end

  # it "is invalid with a 'nil' name" do
  #   publisher = Publisher.new(name: nill)
  #   expect(publisher.valid?).to be false
  # end

  # it 'is invalid with a blank name' do
  #   publisher = Publisher.new(name: '')
  #   expect(publisher.valid?).to be false 
  # end

  # it 'valid with a name' do
  #   publisher = Publisher.new(name: "O'Reilly")
  #   expect(publisher.valid?).to be true
  # end

end
