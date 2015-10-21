task :backup_dev_db, [:filename] do |t, args|
	if args[:filename].nil?
		puts "must specify name of backup file"

	else
		filename = args[:filename]

		command = "pg_dump SOwn_development -f #{filename}"
		`#{command}`

		puts 'backup complete!'
	end
end
