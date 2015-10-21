task :restore_dev_db, [:filename] do |t, args|
	if args[:filename].nil?
		puts "must specify name of backup file"

	else
		filename = args[:filename]

		command = "psql SOwn_development -f #{filename}"
		`#{command}`

		puts 'restore complete!'
	end
end
