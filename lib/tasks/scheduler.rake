# Books return Reminder Task
task :remind_books_return => :environment do
    Reminder.remind_books_return
end
