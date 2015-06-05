require 'rails_helper'
require 'cancan_matchers'

RSpec.describe Ability do
  standard = :read, :create, :update, :destroy

  unsigned = {
    Album.new => { yes: [], no: standard },
    CafeWork.new => {
      yes: [:read],
      no: [:create, :update, :add_worker, :update_worker, :remove_worker, :nyckelpiga]
    },
    Candidate.new => { yes: [], no: standard },
    Constant.new => { yes: [], no: standard },
    Contact.new => { yes: [], no: [:mail, :create, :update, :destroy, :read] },
    Contact.new(public: true) => { yes: [:read, :mail], no: [:create, :update] },
    Council.new => { yes: [:read], no: [:create, :update, :destroy] },
    Document.new(public: true) => { yes: [:read], no: [:create, :update, :destroy] },
    Document.new => { yes: [], no: standard },
    Election.new => { yes: [:index], no: [:create, :update, :destroy] },
    Event.new => { yes: [], no: standard },
    Faq.new => { yes: [:read, :create], no: [:update, :destroy] },
    Menu.new => { yes: [], no: standard },
    News.new => { yes: [:read], no: [:create, :update, :destroy] },
    Nomination.new => { yes: [], no: [:create] },
    Notice.new => { yes: [:display, :image], no: standard },
    PageElement.new => { yes: [], no: standard },
    Page.new => { yes: [:read], no: [:create, :update, :destroy] },
    Permission.new => { yes: [], no: standard },
    Post.new => { yes: [:collapse, :display], no: [:read, :create, :update] },
    Rent.new => { yes: [:main], no: [:create, :update, :destroy] }
  }

  ab_signed = {
    Album.new => { yes: [], no: standard },
    CafeWork.new => {
      yes: [:read, :add_worker],
      no: [:create, :update]
    },
    Candidate.new => { yes: [], no: standard },
    Constant.new => { yes: [], no: standard },
    Contact.new => { yes: [], no: [:mail, :read, :create, :update, :destroy] },
    Contact.new(public: true) => { yes: [:read, :mail], no: [:create, :update] },
    Council.new => { yes: [:read], no: [:create, :update, :destroy] },
    Document.new(public: true) => { yes: [:read], no: [:create, :update, :destroy] },
    Document.new => { yes: [], no: standard },
    Election.new => { yes: [:index], no: [:create, :update, :destroy] },
    Event.new => { yes: [], no: standard},
    Faq.new => { yes: [:read, :create], no: [:update, :destroy] },
    Menu.new => { yes: [], no: standard },
    News.new => { yes: [:read], no: [:create, :update, :destroy] },
    Nomination.new => { yes: [], no: [:create] },
    Notice.new => { yes: [:display, :image], no: standard },
    PageElement.new => { yes: [], no: standard },
    Page.new => { yes: [:read], no: [:create, :update, :destroy] },
    Permission.new => { yes: [], no: standard },
    Post.new => { yes: [:collapse, :display, :show], no: [:index, :create, :update] },
    Rent.new => { yes: [:main, :index, :create], no: [] }
  }

  ab_member = {
    Album.new => { yes: [], no: standard },
    CafeWork.new => {
      yes: [:read, :add_worker],
      no: [:create, :update, :update_worker, :remove_worker, :nyckelpiga]
    },
    Candidate.new => { yes: [:index, :create], no: [] },
    Constant.new => { yes: [], no: standard },
    Contact.new => { yes: [:read, :mail], no: [:create, :update, :destroy] },
    Council.new => { yes: [:read], no: [:create, :update, :destroy] },
    Document.new => { yes: [:read], no: [:create, :update, :destroy] },
    Election.new => { yes: [:index], no: [:create, :update, :destroy] },
    Event.new => { yes: [:read], no: [:create, :update, :destroy] },
    Faq.new => { yes: [:read, :create], no: [:update, :destroy] },
    Menu.new => { yes: [], no: standard },
    News.new => { yes: [:read], no: [:create, :update, :destroy] },
    Nomination.new => { yes: [:create], no: [] },
    Notice.new => { yes: [:display, :image], no: standard },
    PageElement.new => { yes: [], no: standard },
    Page.new => { yes: [:read], no: [:create, :update, :destroy] },
    Permission.new => { yes: [], no: standard },
    Post.new => { yes: [:collapse, :display, :show], no: [:index, :create, :update] },
    Rent.new => { yes: [:main, :create, :index], no: [:update, :destroy] }
  }

  subject(:not_signed_ability) { Ability.new(nil) }

  let(:signed) { create(:user, member_at: nil) }
  subject(:signed_ability) { Ability.new(signed) }

  let(:member) { create(:user, member_at: Time.zone.now) }
  subject(:member_ability) { Ability.new(member) }

  describe 'Not signed in' do
    unsigned.each do |obj, value|
      if value[:yes].present?
        it { not_signed_ability.should have_abilities(value[:yes], obj) }
      end

      if value[:no].present?
        it { not_signed_ability.should not_have_abilities(value[:no], obj) }
      end
    end
  end

  describe 'Signed in' do
    ab_signed.each do |obj, value|
      if value[:yes].present?
        it { signed_ability.should have_abilities(value[:yes], obj) }
      end

      if value[:no].present?
        it { signed_ability.should not_have_abilities(value[:no], obj) }
      end
    end

    # Extra cases which cannot be covered in loop
    # These also count for the members
    it { signed_ability.should have_abilities([:show, :update, :destroy], Rent.new(user: signed)) }
    it do
      signed_ability.should have_abilities([:update_worker, :remove_worker, :edit],
                                           CafeWork.new(user: signed))
    end
  end

  describe 'Member' do
    ab_member.each do |obj, value|
      if value[:yes].present?
        it { member_ability.should have_abilities(value[:yes], obj) }
      end

      if value[:no].present?
        it { member_ability.should not_have_abilities(value[:no], obj) }
      end
    end

    # Extra cases which cannot be covered in loop
    it do
      member_ability.should have_abilities([:update, :show, :destroy],
                                           Candidate.new(user: member))
    end
  end

end
