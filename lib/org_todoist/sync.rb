module OrgTodoist
  class Sync
    attr_reader :projects, :org_head

    def initialize org_file, out_file, api=OrgTodoist.api
      @api      = api
      @org_file = org_file
      @out_file = out_file
      @projects = []
    end

    def sync!
      pull_todoist
      import_org_file
      push_todoist_projects
      push_todoist_items
      fetch_todoist_changes
      export_org_file
      true
    end

    def import_org_file
      @org_head = OrgFormat::Headline.parse_org_file(@org_file)
      OrgTodoist::Converter.to_todoist_projects(@org_head).each do |pj|
        @projects << pj
      end
    end

    def pull_todoist
      @api.pull
    end

    def push_todoist_projects
      @projects.each do |pj|
        pj.save! @api
      end
      @api.push
    end

    def push_todoist_items
      @projects.each do |pj|
        pj.items.each do |itm|
          itm.save! @api
        end
      end
      @api.push
    end

    def fetch_todoist_changes
      @org_head.all_sub_headlines.each do |headline|
        if obj = headline.todoist_obj
          OrgTodoist::Converter.from_todoist_obj(headline, obj)
        end
      end
    end

    def export_org_file
      open(@out_file, 'w') do |file|
        expt = OrgFormat::Exporter.new(file)
        @org_head.headlines.each do |headline|
          expt.print_headline(headline)
        end
      end
    end
  end
end
