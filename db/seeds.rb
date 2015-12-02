@user = User.create!(
  uid: 314159265,
  provider: 'meetup',
  name: Faker::Name.name,
  wit_member: true,
  admin: true
  )
@board = Board.create!(
  title: Faker::Lorem.sentence(2),
  description: Faker::Lorem.paragraph(2)
)

25.times do
  @article = @user.articles.create!( title: Faker::Lorem.sentence, content: Faker::Lorem.paragraphs.join('/n') )
  15.times do
    @user.comments.create!(
      commentable_type: Article,
      commentable_id: @article.id,
      content: Faker::Lorem.sentence
    )
  end
end

25.times do
  @topic = @board.topics.create!(
    user_id: @user.id,
    title: Faker::Lorem.sentence,
    content: Faker::Lorem.paragraph(3)
  )
  15.times do
    @user.comments.create!(
      commentable_type: Topic,
      commentable_id: @topic.id,
      content: Faker::Lorem.sentence
    )
  end
end
