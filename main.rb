# frozen_string_literal: true

require "octokit"

TIME_FMT = "%Y-%m-%d %H:%M:%S %Z"
SINCE = Time.new(2023, 6, 9, 0, 0, 0, "UTC")

client = Octokit::Client.new(:access_token => ENV["GITHUB_TOKEN"])
client.auto_paginate = true

new_issues = client.list_issues("apache/arrow", {
    since: SINCE.strftime(TIME_FMT)
}).filter { |i| i[:created_at] >= SINCE }

puts "NEW ISSUES"
new_issues.each do |issue|
    puts issue[:title]
end

new_pulls = client.pull_requests("apache/arrow", {
    since: SINCE.strftime(TIME_FMT)
}).filter { |i| i[:created_at] >= SINCE }

puts "NEW_PULLS"
new_pulls.each do |pull|
    puts pull[:title]
end
