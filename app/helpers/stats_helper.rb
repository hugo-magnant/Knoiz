module StatsHelper
    def display_stats?
        params[:page] == "stats"
    end
    def display_tops?
      params[:page] == "tops"
    end
    def display_recently?
        params[:page] == "recently"
    end
    def display_top_global?
        params[:page] == "top_global"
    end
end