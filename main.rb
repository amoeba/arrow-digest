# frozen_string_literal: true

require "octokit"

TIME_FMT = "%Y-%m-%d %H:%M:%S %Z"

class Report
  @client = nil

  attr_reader :new_issues, :new_pull_requests

  def initialize
    @client = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
    @client.auto_paginate = true
    set_time_range
  end

  def set_time_range
    now = Time.now.utc
    @since = Time.new(now.year, now.month, now.day - 1, 0, 0, 0, "UTC")
    @until = Time.new(now.year, now.month, now.day, 0, 0, 0, "UTC")
  end

  def fetch_data
    fetch_new_issues
    fetch_new_pull_requests
  end

  def fetch_new_issues
    @new_issues = @client.list_issues("apache/arrow", {
      since: @since.strftime(TIME_FMT)
    }).filter { |i| i[:created_at] >= @since && i[:created_at] < @until }
  end

  def fetch_new_pull_requests
    @new_pull_requests = @client.pull_requests("apache/arrow", {
      since: @since.strftime(TIME_FMT)
    }).filter { |i| i[:created_at] >= @since && i[:created_at] < @until }
  end
end

report = Report.new
report.fetch_data

report.new_issues.each do |issue|
  puts issue[:title]
end

report.new_pull_requests.each do |pull|
  puts pull[:title]
end
