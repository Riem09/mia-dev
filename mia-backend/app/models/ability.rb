class Ability
  include CanCan::Ability

  def initialize(user)

    can :read, :all
    can :typeahead, Motif
    can :random, Motif
    can :search, :all

    if (user)
      if user.admin?
        can :manage, all
      else
        can :manage, Video do |video| video.try(:owner) == user end
        can :manage, Motif do |motif| video.try(:owner) == user end
        can :manage, VideoMotif do |videomotif| video.try(:owner) == user end
      end
    end

  end
end
