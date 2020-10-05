require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should belong_to(:user).optional }
  it { should belong_to(:question) }

  it { should validate_presence_of :name }

  it 'has one attached image' do
    expect(Badge.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
