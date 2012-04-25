require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))


describe '#load_capistrano_recipe' do
  Capistrano::Configuration.instance = Capistrano::Configuration.new
  load_capistrano_recipe(Capistrano::Recipes::Bark)

  it 'extends the config' do
    Capistrano::Configuration.instance.must_respond_to :uploads
  end

  it 'loads the specified recipe into the instance configuration' do
    Capistrano::Configuration.instance.must_have_task "bark"
  end

  it 'sets the capistrano instance to the extend config' do
    Capistrano::Configuration.instance.must_equal recipe
  end

  it 'sets recipe to the config for reference' do
    recipe.must_equal Capistrano::Configuration.instance
  end

  it 'sets subject to the config for reference' do
    subject.must_equal Capistrano::Configuration.instance
  end

  it 'holds onto the original config' do
    @orig_config.must_be_instance_of Capistrano::Configuration.instance.class
    @orig_config.wont_equal Capistrano::Configuration.instance
  end
end
