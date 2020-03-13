require 'rails_helper'

describe 'Answers API', type: :request do
  ANSWER_PUBLIC_FIELDS = %w[id body created_at updated_at].freeze

  let(:headers) {
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  }

  describe 'GET /api/v1/answers/:id' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, :with_files, question: question) }
    let!(:links) { (create_list(:link, 3, linkable: answer)) }
    let!(:comments) { (create_list(:comment, 2, author: user, commentable: answer)) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns one answer' do
        expect(json.size).to eq 1
      end

      it 'returns correct answer' do
        expect(json['answer']['id']).to eq answer.id
      end

      it 'returns all public fields' do
        ANSWER_PUBLIC_FIELDS.each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(json['answer']['author']['id']).to eq answer.author.id
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { json['answer']['comments'].last }

        it 'contains comments' do
          expect(json['answer']['comments'].size).to eq 2
        end

        it 'comment has needed fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_response) { json['answer']['links'].last }

        it 'contains links' do
          expect(json['answer']['links'].size).to eq 3
        end

        it 'link has needed fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { answer.files.first }
        let(:file_response) { json['answer']['files'].last }

        it 'contains files' do
          expect(json['answer']['files'].size).to eq 1
        end

        it 'file has needed fields' do
          %w[id url filename created_at].each do |attr|
            expect(file_response[attr]).to eq attr == 'url' ? Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true)\
                                                            : file.send(attr).as_json
          end
        end
      end
    end
  end
end
