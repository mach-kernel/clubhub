class Person < ActiveRecord::Base
	# Hack to add temporary attribute
	attr_accessor :role

	self.table_name = "person"
end
