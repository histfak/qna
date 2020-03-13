require 'rails_helper'

describe 'Answers API', type: :request do
  let(:answer_public_fields) { %w[id body created_at updated_at] }
  let(:comment_public_fields) { %w[id body created_at updated_at] }
  let(:link_public_fields) { %w[id name url created_at updated_at] }
  let(:file_public_fields) { %w[id url filename created_at] }

  let(:headers) {
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  }

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, :with_files, question: question) }
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
        answer_public_fields.each do |attr|
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
          comment_public_fields.each do |attr|
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
          link_public_fields.each do |attr|
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
          file_public_fields.each do |attr|
            expect(file_response[attr]).to eq attr == 'url' ? Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true)\
                                                            : file.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'valid attributes' do
        let(:access_token) { create(:access_token) }
        let(:question) { create(:question) }
        let(:answer) { Answer.last }

        before { post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer) }, headers: headers }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'saves a new question to the database' do
          expect { post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
        end

        it "returns public fields" do
          answer_public_fields.each do |attr|
            expect(json['question']['answers'].first[attr]).to eq answer.send(attr).as_json
          end
        end
      end

      context 'invalid attributes' do
        let(:access_token) { create(:access_token) }

        before { post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }, headers: headers }

        it 'returns 422 status' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'saves a new question to the database' do
          expect { post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) } }.not_to change(Answer, :count)
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:author) { create(:user) }
    let!(:answer) { create(:answer, author: author) }
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'author' do
        let(:access_token) { create(:access_token, resource_owner_id: author.id).token }

        context 'valid attributes' do
          before { patch api_path, params: { access_token: access_token, answer: { body: 'new body' } }, headers: headers }

          it 'returns 200 status' do
            expect(response).to be_successful
          end

          it 'updates answer in DB' do
            expect(answer.reload.body).to eq 'new body'
          end

          it "returns public fields" do
            answer_public_fields.each do |attr|
              expect(json['answer'][attr]).to eq answer.reload.send(attr).as_json
            end
          end
        end

        context 'invalid attributes' do
          before { patch api_path, params: { access_token: access_token, answer: attributes_for(:answer, :invalid) }, headers: headers }

          it 'returns 422 status' do
            expect(response).to have_http_status :unprocessable_entity
          end

          it 'does not change answer' do
            answer_public_fields.each do |attr|
              expect do
                patch api_path, params: { id: answer, answer: attributes_for(:answer, :invalid) }
                answer.reload
              end.to_not change(answer, attr)
            end
          end
        end
      end

      context 'not author' do
        let(:access_token) { create(:access_token).token }
        let!(:answer) { create(:answer) }

        before { patch api_path, params: { access_token: access_token, answer: { body: 'new body' } }, headers: headers }

        it 'returns 403 status in json answer' do
          expect(json['status']).to eq 403
        end

        it 'does not change answer' do
          answer_public_fields.each do |attr|
            expect do
              patch api_path, params: { id: answer, answer: { body: 'new body' }, headers: headers }
              answer.reload
            end.to_not change(answer, attr)
          end
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:author) { create(:user) }
    let!(:answer) { create(:answer, author: author) }
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'author' do
        let(:access_token) { create(:access_token, resource_owner_id: author.id).token }

        before { delete api_path, params: { access_token: access_token, id: answer }, headers: headers }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'deletes answer in DB' do
          expect { answer.reload }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context 'not author' do
        let(:access_token) { create(:access_token).token }
        let!(:answer) { create(:answer) }

        before { delete api_path, params: { access_token: access_token, id: answer }, headers: headers }

        it 'returns 403 status in json answer' do
          expect(json['status']).to eq 403
        end

        it 'does not change answer' do
          answer_public_fields.each do |attr|
            expect do
              delete api_path, params: { access_token: access_token, id: answer }, headers: headers
              answer.reload
            end.to_not change(answer, attr)
          end
        end
      end
    end

    context 'unauthorized' do
      let!(:answer) { create(:answer) }

      before { delete api_path, params: { id: answer }, headers: headers }

      it 'returns 401 status' do
        expect(response).to have_http_status 401
      end

      it 'does not change question' do
        answer_public_fields.each do |attr|
          expect do
            delete api_path, params: { id: answer }, headers: headers
            answer.reload
          end.to_not change(answer, attr)
        end
      end
    end
  end
end
