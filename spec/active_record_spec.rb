require_relative "spec_helper"
require "active_record"

ActiveRecord::Base.send(:include, RainTable::ActiveRecord)
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
  end
end

class User < ActiveRecord::Base
end

describe RainTable::ActiveRecord do
  before do
    2.times{|i| User.create!(:name => i) }
  end

  it do
    User.to_t.should == <<-EOT.strip_heredoc
+----+------+
| id | name |
+----+------+
|  1 |    0 |
|  2 |    1 |
+----+------+
EOT
    User.first.to_t.should == <<-EOT.strip_heredoc
+------+---+
| id   | 1 |
| name | 0 |
+------+---+
EOT
  end
end
