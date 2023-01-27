shared_examples_for 'Model have nested' do
  it { should have_one(:meed).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }
end
