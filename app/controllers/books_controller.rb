# @author nirina
# BooksController Class
class BooksController < ApplicationController
  # deny non authenticated user to enter served pages
  before_action :authenticate_user!
  before_action :set_current_user

  # create a comment of book :id
  # @example POST /books/:id/comment
  #   request params = { content: 'comment content' }
  # Redirect to /store/:id with success message if the comment is successfully created
  # Redirect to /store/:id with error message if the comment is not valid
  # @return [ActionView::Renderer] default 404 page if the book does not exists
  def comments_create
    # retrieve the book to comment
    @book = Book.friendly.find(params[:id])
    # create a new comment by assigning it the book and the content param
    @comment = Comment.new(user: current_user, book: @book, content: params[:comment][:content])

    # check if the comment is valid
    if @comment.valid?
      # save the comment in db
      @comment.save
      # redirect to book show page with a success message
      redirect_to store_show_path, notice: 'Your comment has been successfully added'
    else
      # redirect to book show page with an error message
      redirect_to store_show_path, alert: @comment.errors.full_messages.first
    end
  end

  # POST '/books/:id/loan'
  # Create a loan for the book with id :id
  # Redirect to /store/:id with success message if the book is successfully borrowed
  # Redirect to /store/:id with error message if the book is not available
  # @return [ActionView::Renderer] default 404 page if the book does not exists
  def loan
    # retrieve the book objet to be loaned
    @book = Book.friendly.find(params[:id])
    # check if the book is available
    if @book.available?
      @book.status = Book.statuses[:borrowed]
      @book.save
      # redirect to book show page with a success message
      redirect_to store_show_path, notice: 'You have successfully borrowed this book'
    else
      # redirect to book show page with an error message
      redirect_to store_show_path, alert: 'This book is not available, you can not borrow this'
    end
  end

  # GET '/books/:id/availability'
  # Get book (of id :id) availability info 
  # Redirect to /store/:id with success message
  # @return [ActionView::Renderer] default 404 page if the book does not exists
  def availability
    # retrieve the book object
    @book = Book.friendly.find(params[:id])
    BookMailer.availability(book: @book, user: current_user).deliver_later
    # redirect to book show page with a success message
    redirect_to store_show_path, notice: 'An email has been sent to you about the current state of this book'
  end
end
