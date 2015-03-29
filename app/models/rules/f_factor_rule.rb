module Rules
  class FFactorRule
    F_FACTORS = {
        2001 => {Downhill: 1280, :"Super G" => 1030, :"Giant Slalom" => 830, Slalom: 570},
        2003 => {Downhill: 1320, :"Super G" => 1050, :"Giant Slalom" => 870, Slalom: 600},
        2008 => {Downhill: 1350, :"Super G" => 1030, :"Giant Slalom" => 880, Slalom: 610},
        2009 => {Downhill: 1320, :"Super G" => 1060, :"Giant Slalom" => 880, Slalom: 600},
        2011 => {Downhill: 1330, :"Super G" => 1060, :"Giant Slalom" => 870, Slalom: 610},
        2013 => {Downhill: 1370, :"Super G" => 1050, :"Giant Slalom" => 890, Slalom: 620},
        2015 => {Downhill: 1250, :"Super G" => 1080, :"Giant Slalom" => 980, Slalom: 720},
    }

    def self.f_factor(race)
      F_FACTORS[F_FACTORS.keys.select { |s| s <= race.season }.max][race.discipline.to_sym]
    end
  end
end