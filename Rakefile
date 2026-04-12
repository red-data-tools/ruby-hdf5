# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rbconfig'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

namespace :test do
  desc 'Run all example scripts'
  task :examples do
    ruby = RbConfig.ruby
    FileList['examples/*.rb'].sort.each do |example|
      sh ruby, '-Ilib', example
    end
  end
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[test]
