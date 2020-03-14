require 'rails_helper'

describe 'Questions API', type: :request do
  let(:question_public_fields) { %w[id title body created_at updated_at] }
  let(:answer_public_fields) { %w[id body created_at updated_at] }
  let(:comment_public_fields) { %w[id body created_at updated_at] }
  let(:link_public_fields) { %w[id name url created_at updated_at] }
  let(:file_public_fields) { %w[id url filename created_at] }

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
      let(:access_token) { create(:access_token).token }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        question_public_fields.each do |attr|
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
          answer_public_fields.each do |attr|
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
      let(:access_token) { create(:access_token).token }

      before { get api_path, params: { access_token: access_token }, headers: headers }

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
        question_public_fields.each do |attr|
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
          answer_public_fields.each do |attr|
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
          comment_public_fields.each do |attr|
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
          link_public_fields.each do |attr|
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
          file_public_fields.each do |attr|
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
        let(:access_token) { create(:access_token).token }
        let(:question) { Question.last }

        before { post api_path, params: { access_token: access_token, question: attributes_for(:question) }, headers: headers }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'saves a new question to the database' do
          expect { post api_path, params: { access_token: access_token, question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end

        it "returns public fields" do
          question_public_fields.each do |attr|
            expect(json['question'][attr]).to eq question.send(attr).as_json
          end
        end
      end

      context 'invalid attributes' do
        let(:access_token) { create(:access_token).token }

        before { post api_path, params: { access_token: access_token, question: attributes_for(:question, :invalid) }, headers: headers }

        it 'returns 422 status' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'saves a new question to the database' do
          expect { post api_path, params: { access_token: access_token, question: attributes_for(:question, :invalid) } }.not_to change(Question, :count)
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'author' do
        let(:access_token) { create(:access_token, resource_owner_id: author.id).token }

        context 'valid attributes' do
          before { patch api_path, params: { access_token: access_token, question: { title: 'new title', body: 'new body' } }, headers: headers }

          it 'returns 200 status' do
            expect(response).to be_successful
          end

          it 'updates question in DB' do
            question.reload
            expect(question.title).to eq 'new title'
            expect(question.body).to eq 'new body'
          end

          it "returns public fields" do
            question_public_fields.each do |attr|
              expect(json['question'][attr]).to eq question.reload.send(attr).as_json
            end
          end
        end

        context 'invalid attributes' do
          before { patch api_path, params: { access_token: access_token, question: attributes_for(:question, :invalid) }, headers: headers }

          it 'returns 422 status' do
            expect(response).to have_http_status :unprocessable_entity
          end

          it 'does not change question' do
            question_public_fields.each do |attr|
              expect do
                patch api_path, params: { id: question, question: attributes_for(:question, :invalid) }
                question.reload
              end.to_not change(question, attr.to_sym)
            end
          end
        end
      end

      context 'not author' do
        let(:access_token) { create(:access_token).token }
        let!(:question) { create(:question) }

        before { patch api_path, params: { access_token: access_token, question: { title: 'new title', body: 'new body' } }, headers: headers }

        it 'returns 403 status in json answer' do
          expect(json['status']).to eq 403
        end

        it 'does not change question' do
          question_public_fields.each do |attr|
            expect do
              patch api_path, params: { id: question, question: { title: 'new title', body: 'new body' } }
              question.reload
            end.to_not change(question, attr.to_sym)
          end
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'author' do
        let(:access_token) { create(:access_token, resource_owner_id: author.id).token }

        before { delete api_path, params: { access_token: access_token, id: question }, headers: headers }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'deletes question in DB' do
          expect { question.reload }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context 'not author' do
        let(:access_token) { create(:access_token).token }
        let!(:question) { create(:question) }

        before { delete api_path, params: { access_token: access_token, id: question }, headers: headers }

        it 'returns 403 status in json answer' do
          expect(json['status']).to eq 403
        end

        it 'does not change question' do
          question_public_fields.each do |attr|
            expect do
              delete api_path, params: { access_token: access_token, id: question }, headers: headers
              question.reload
            end.to_not change(question, attr.to_sym)
          end
        end
      end
    end

    context 'unauthorized' do
      let!(:question) { create(:question) }

      before { delete api_path, params: { id: question }, headers: headers }

      it 'returns 401 status' do
        expect(response).to have_http_status 401
      end

      it 'does not change question' do
        question_public_fields.each do |attr|
          expect do
            delete api_path, params: { id: question }, headers: headers
            question.reload
          end.to_not change(question, attr.to_sym)
        end
      end
    end
  end
end
