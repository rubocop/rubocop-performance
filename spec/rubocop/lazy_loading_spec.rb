# frozen_string_literal: true

RSpec.describe 'cop lazy loading' do # rubocop:disable RSpec/DescribeClass
  def run_script(source)
    Dir.mktmpdir do |dir|
      script = File.join(dir, 'script.rb')
      File.write(script, source)
      lib = File.expand_path('../../lib', __dir__)
      output = `#{RbConfig.ruby} -I #{lib} #{script} 2>&1`
      raise "script failed:\n#{output}" unless $CHILD_STATUS.success?

      output
    end
  end

  it 'registers all cops without loading their files' do
    lib = File.expand_path('../../lib', __dir__)

    output = run_script(<<~RUBY)
      require 'rubocop-performance'

      registry = RuboCop::Cop::Registry.global
      loaded = $LOADED_FEATURES.grep(%r{/rubocop/cop/performance/})
      loaded_mixins = $LOADED_FEATURES.select { |feature| feature.start_with?('#{lib}/rubocop/cop/mixin/') }

      puts "registered=\#{registry.names.grep(%r{\\APerformance/}).size}"
      puts "loaded_cop_files=\#{loaded.size}"
      puts "loaded_mixin_files=\#{loaded_mixins.size}"
    RUBY

    expect(output).to include('registered=52', 'loaded_cop_files=0', 'loaded_mixin_files=0')
  end

  it 'does not register a cop twice when its file is required directly' do
    output = run_script(<<~RUBY)
      require 'rubocop-performance'

      before = RuboCop::Cop::Registry.global.length
      require 'rubocop/cop/performance/bind_call'
      after = RuboCop::Cop::Registry.global.length

      puts "stable=\#{before == after}"
      puts "class=\#{RuboCop::Cop::Registry.global.find_by_cop_name('Performance/BindCall')}"
    RUBY

    expect(output).to include('stable=true', 'class=RuboCop::Cop::Performance::BindCall')
  end
end
