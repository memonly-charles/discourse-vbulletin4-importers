# Add the following "permalink normalizations" in Admin settings to get these redirects to work.
#
# Example 1
# http://your.vbulletindomain.com/forums/f10/some-thread-title-here-51689/index1.html
# http://your.vbulletindomain.com/forums/f10/some-thread-title-here-51689/index15.html#323423
#
# Normalization 1. This is for the above 2 examples. Add this one first (order of normalizations is important!)
# /(forums)\/f[0-9]+\/.+-([0-9]+)\/index[0-9]*.html/\1\2
#
# Example 2
# http://your.vbulletindomain.com/forums/f10/some-thread-title-here-51689/
#
# Normalization 2. This is for the above example. Add this one normalization second (order of normalizations is important!)
# /(forums)\/f[0-9]+\/.+-([0-9]+)/\1\2

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
    total_count = Topic.count
    Topic.find_each do |topic|
      next if topic.archetype == Archetype.private_message #ids starting with 1073741824 are private messages, ensure we don't get those
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
