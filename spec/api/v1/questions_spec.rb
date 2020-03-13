require 'rails_helper'

describe 'Questions API', type: :request do
  QUESTION_PUBLIC_FIELDS = %w[id title body created_at updated_at].freeze
  ANSWER_PUBLIC_FIELDS = %w[id body created_at updated_at].freeze
  COMMENT_PUBLIC_FIELDS = %w[id body created_at updated_at].freeze
  LINK_PUBLIC_FIELDS = %w[id name url created_at updated_at].freeze
  FILE_PUBLIC_FIELDS = %w[id url filename created_at].freeze

  let(:headers) {
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        QUESTION_PUBLIC_FIELDS.each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].last }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          ANSWER_PUBLIC_FIELDS.each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_files) }
    let!(:answers) { (create_list(:answer, 3, question: question)) }
    let!(:links) { (create_list(:link, 3, linkable: question)) }
    let!(:comments) { (create_list(:comment, 2, author: user, commentable: question)) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns one question' do
        expect(json.size).to eq 1
      end

      it 'returns correct question' do
        expect(json['question']['id']).to eq question.id
      end

      it 'returns all public fields' do
        QUESTION_PUBLIC_FIELDS.each do |attr|
          expect(json['question'][attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(json['question']['author']['id']).to eq question.author.id
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { json['question']['answers'].last }

        it 'contains answers' do
          expect(json['question']['answers'].size).to eq 3
        end

        it 'answer has needed fields' do
          ANSWER_PUBLIC_FIELDS.each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { json['question']['comments'].last }

        it 'contains comments' do
          expect(json['question']['comments'].size).to eq 2
        end

        it 'comment has needed fields' do
          COMMENT_PUBLIC_FIELDS.each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_response) { json['question']['links'].last }

        it 'contains links' do
          expect(json['question']['links'].size).to eq 3
        end

        it 'link has needed fields' do
          LINK_PUBLIC_FIELDS.each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { question.files.first }
        let(:file_response) { json['question']['files'].last }

        it 'contains files' do
          expect(json['question']['files'].size).to eq 1
        end

        it 'file has needed fields' do
          FILE_PUBLIC_FIELDS.each do |attr|
            expect(file_response[attr]).to eq attr == 'url' ? Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true)\
                                                            : file.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'valid attributes' do
        let(:access_token) { create(:access_token) }

        before { post api_path, params: { access_token: access_token.token, question: attributes_for(:question) } }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'saves a new question to the database' do
          expect { post api_path, params: { access_token: access_token.token, question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end
      end
    end
  end
end
