class Ability
  include CanCan::Ability

  def initialize(user)

    if user.role.eql?(USER_ROLE_ADMIN)
      can :manage, :all

      cannot :view, Snap do |snap|
        !snap.recipient_ids.include? user.id
      end

      cannot :image, Snap do |snap|
        !snap.recipient_ids.include?(user.id) || !(snap.view_count(user.id) < 1)
      end
    else
      can :manage, User, id: user.id
      cannot :index, User

      can :manage, FriendInvitation, author_id: user.id
      can :manage, FriendInvitation, recipient_id: user.id
      can :accept, FriendInvitation, recipient_id: user.id
      cannot :accept, FriendInvitation do |invitation|
        !invitation.recipient_id.eql? user.id
      end
      can :reject, FriendInvitation, recipient_id: user.id
      cannot :reject, FriendInvitation do |invitation|
        !invitation.recipient_id.eql? user.id
      end
      can :cancel, FriendInvitation, author_id: user.id
      cannot :cancel, FriendInvitation do |invitation|
        !invitation.author_id.eql? user.id
      end
      cannot :index, FriendInvitation

      can :manage, Snap, user_id: user.id
      can :manage, Snap do |snap|
        snap.recipient_ids.include?(user.id)
      end
      cannot :index, Snap
      cannot :view, Snap do |snap|
        !snap.recipient_ids.include? user.id
      end
      cannot :image, Snap do |snap|
        !snap.recipient_ids.include?(user.id) || !(snap.view_count(user.id) < 1)
      end
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
