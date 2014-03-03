require 'sinatra'
require 'shotgun'

set :views, File.dirname(__FILE__) + '/views'
set :public_folder, File.dirname(__FILE__) + '/public'

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
    game.select { |key,value|
     if (key == :home_team || key ==:away_team)
      unless @teams.find{ |team| team[:name] == value }
        @teams << { name: value, wins: 0, losses: 0 }
      end
     end
    }
    if  game[:home_score] > game[:away_score]
     win_index = @teams.index{ |team| team[:name] == game[:home_team] }
     lose_index = @teams.index{ |team| team[:name] == game[:away_team] }
    elsif  game[:home_score] < game[:away_score]
     lose_index = @teams.index{ |team| team[:name] == game[:home_team] }
     win_index = @teams.index{ |team| team[:name] == game[:away_team] }
    end
     @teams[win_index][:wins] +=  1
     @teams[lose_index][:losses] +=  1
  end

   @win = @teams.sort_by{ |team| team[:wins] }.reverse
   @lose = @teams.sort_by{ |team| team[:losses] }.reverse

 haml :index

end
