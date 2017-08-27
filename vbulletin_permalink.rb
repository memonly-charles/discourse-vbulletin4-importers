require File.expand_path(File.dirname(__FILE__) + "/base.rb")

# See https://meta.discourse.org/t/importing-from-vbulletin-4/54881
# Please update there if substantive changes are made!

class ImportScripts::VBulletin < ImportScripts::Base

  def initialize
    super
  end

  def execute
    permalink_everything
  end

  def permalink_everything
    puts "importing permalinks"
    current_count = 0
    total_count = Topic.where('id < 1073741824').count
    Topic.find_each do |topic|
      next if topic.id >= 2**30 #ids starting with 1073741824 are private messages, ensure we don't get those
      current_count += 1
      print_status current_count, total_count
      old_topic_id = topic.custom_fields["import_id"]
      if old_topic_id
        Permalink.create(url: "forums#{old_topic_id}", topic_id: topic.id)
      end
    end
  end

end

ImportScripts::VBulletin.new.execute
