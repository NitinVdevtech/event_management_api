class Api::V1::EventsController < ApplicationController
  before_action :authorize_request, only: [:create, :update, :destroy, :index]
  before_action :set_event, only: [:show, :update, :destroy]
  load_and_authorize_resource

  def index
    events = Event.all
    events = events.paginate(page: params[:page], per_page: 10)
    events = events.where("name LIKE ?", "%#{params[:name]}%") if params[:name].present?
    events = events.where(location: params[:location]) if params[:location].present?
    if params[:start_time].present? && params[:end_time].present?
      events = events.where(start_time: params[:start_time]..params[:end_time])
    elsif params[:start_time].present?
      events = events.where("start_time >= ?", params[:start_time])
    elsif params[:end_time].present?
      events = events.where("end_time <= ?", params[:end_time])
    end
    render json: events
  end

  def show
    render json: @event
  end

  def create
    event = @current_user.events.build(event_params)
    if event.save
      render json: event, status: :created
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @event.destroy
      render json: { message: 'Event deleted successfully' }, status: :ok
    else
      render json: { errors: 'Failed to delete event' }, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :description, :location, :start_time, :end_time)
  end

  rescue_from CanCan::AccessDenied do |exception|
    render json: { errors: exception.message }, status: :forbidden
  end
end
