require 'rails_helper'

RSpec.describe Page, type: :model do
  it 'has a valid factory' do
    build(:page).should be_valid
  end

  describe 'validations' do
    it 'validates url' do
      page = build(:page, url: 'abc')
      page.should validate_presence_of(:url)
      page.should allow_value('abc_123-abc').for(:url)
      page.should_not allow_value('ABC').for(:url)
      page.should_not allow_value('https://illegal.com').for(:url)
    end
  end

  context 'page elements' do
    describe 'main' do
      it 'returns all visible main fields' do
        page = create(:page)
        create(:page_element, page: page, name: 'Second',
                              visible: true, index: 10, sidebar: false)

        create(:page_element, page: page, name: 'First',
                              visible: true, index: 1, sidebar: false)

        create(:page_element, page: page, name: 'Not visible',
                              visible: false, sidebar: false)

        create(:page_element, page: page, name: 'Sidebar',
                              visible: true, sidebar: true)

        create(:page_element, name: 'Other page',
                              visible: true, sidebar: false)

        page.main.map(&:name).should eq(['First', 'Second'])
      end
    end

    describe 'side' do
      it 'returns all visible sidebar fields' do
        page = create(:page)
        create(:page_element, page: page, name: 'Second',
                              visible: true, index: 10, sidebar: true)

        create(:page_element, page: page, name: 'Not visible',
                              visible: false, index: 5, sidebar: true)

        create(:page_element, page: page, name: 'First',
                              visible: true, index: 1, sidebar: true)

        create(:page_element, page: page, name: 'Main field',
                              visible: true, index: 10, sidebar: false)

        create(:page_element, name: 'Other page',
                              visible: true, index: 10, sidebar: true)

        page.side.map(&:name).should eq(['First', 'Second'])
      end
    end
  end
end
