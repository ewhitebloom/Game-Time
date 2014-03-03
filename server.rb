require 'sinatra'

def find_team(teams, team_name)
  teams.find { |team| team[:name] == team_name }
end

def find_or_create_team(teams, team_name)
  team = find_team(teams, team_name)
  team = create_team(teams, team_name) if team.nil?
  team
end

def create_team(teams, team_name)
  team = { name: team_name, wins: 0, losses: 0 }
  teams << team
  team
end

def update_stats(game, teams)
  if game[:home_score] > game[:away_score]
    winner = find_or_create_team(teams, game[:home_team])
    loser = find_or_create_team(teams, game[:away_team])
  elsif game[:home_score] < game[:away_score]
    winner = find_or_create_team(teams, game[:away_team])
    loser = find_or_create_team(teams, game[:home_team])
  end

  winner[:wins] +=  1
  loser[:losses] +=  1
end

get '/' do
  redirect '/leaderboard'
end

get '/leaderboard' do
  @data = [
    {
      home_team: "Patriots",
      away_team: "Broncos",
      home_score: 7,
      away_score: 3
    },
    {
      home_team: "Broncos",
      away_team: "Colts",
      home_score: 3,
      away_score: 0
    },
    {
      home_team: "Patriots",
      away_team: "Colts",
      home_score: 11,
      away_score: 7
    },
    {
      home_team: "Steelers",
      away_team: "Patriots",
      home_score: 7,
      away_score: 21
    }
  ]

  @teams = []

  @data.each do |game|
    update_stats(game, @teams)
  end

  @teams.sort_by! { |team| [-team[:wins], team[:losses]] }

  @winners = @teams.sort_by{ |team| team[:wins] }.reverse
  @losers = @teams.sort_by{ |team| team[:losses] }.reverse

  erb :leaderboard
end
