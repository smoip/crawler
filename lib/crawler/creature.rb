module Crawler
  class Creature
    include Crawler::Dice
    include Crawler::Errors

    attr_accessor :name, :hp, :max_hp, :xp, :level, :loot, :base_attack, :base_defense

    MAX_LEVEL = 10

    def initialize(attrs = {})
      @name = attrs[:name] || generate_name
      @max_hp = attrs[:max_hp] || 1
      @hp = attrs[:hp] || @max_hp
      @xp = attrs[:xp] || 0
      @level = attrs[:level] || 0
      @base_attack = attrs[:base_attack] || 1
      @base_defense = attrs[:base_defense] || initial_defense
      @loot = attrs[:loot] || {}
    end

    def level_up(opts = { force: false })
      return unless calculated_level > level || opts[:force]
      increase_attributes
      @level += 1
      min_xp = level_map[level]
      return unless xp < min_xp
      @xp = min_xp
    end

    def gain_xp(amount)
      raise Crawler::Errors::CreatureError.new("Can't gain negative xp") if amount < 0
      @xp += amount
      check_level
    end

    def attack_power
      @base_attack + attack_modifiers
    end

    def defense_power
     @base_defense + defense_modifiers
    end

    def attack(target)
      return unless succeeds?(attack_power, target.defense_power)
      target.lose_hp(roll_d(attack_power))
      target.dead? ? gain_xp(target.defeat_value) : (target.hit_value)
    end

    def gain_hp(amount)
      change_hp(amount)
    end

    def lose_hp(amount)
      change_hp(amount * -1)
    end

    def dead?
      hp < 1
    end

    def hit_value
      level
    end

    def defeat_value
      level * 2
    end

    private

    def initial_defense
      Crawler::Config.settings[:base]
    end

    # Name methods

    # override for different naming rules
    def generate_name
      self.class.name.split("::").last
    end

    # Level generics

    def check_level
      level_diff = calculated_level - level
      return unless level_diff > 0
      level_diff.times { level_up }
    end

    def calculated_level
      level_map.index(next_lev_threshold)
    end

    def next_lev_threshold
      level_map.select { |i| i >= xp }.first || level_map[MAX_LEVEL - 1]
    end

    # Level Progression

    # override for different progression rates
    def level_map
      @level_map ||= (0..MAX_LEVEL).map { |i| (2 ** i) * 10 }
    end

    # override for different progression behaviors
    def increase_attributes
      # increase hp
      @max_hp += roll_d(4)
      # increase base_attack
      @base_attack += roll_d(3)
      # increase base_defense
      @base_defense += roll_d(3)
    end

    # Modifiers

    def attack_modifiers
      # logic for item/status based modifiers here
      0
    end

    def defense_modifiers
      # logic for item/status based modifiers here
      0
    end

    def change_hp(amount)
      @hp += amount
      if hp > max_hp
        @hp = max_hp
      elsif hp.negative?
        @hp = 0
      end
    end
  end
end
