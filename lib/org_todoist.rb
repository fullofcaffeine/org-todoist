module OrgTodoist
  def self.configure
    @token = ENV["ORG_TODOIST_TOKEN"]
  end

  def self.token
    @token
  end

  def self.api
    @api ||= OrgTodoist::Api.new
  end

  def self.uuid
    `uuidgen`.chomp
  end
end

# monkey-patch
class String
  def mb_width
    each_char.map{|c| c.bytesize == 1 ? 1 : 2}.reduce(0, &:+)
  end
end

require 'org_todoist/model'
require 'org_todoist/api'
require 'org_todoist/project'
require 'org_todoist/item'
require 'org_todoist/sync'
require 'org_todoist/converter'

require 'org_format/exporter'
require 'org_format/headline'
require 'org_format/schedule'
require 'org_format/clock_log'
