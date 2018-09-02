class EventEntryPassesController < ApplicationController
  before_action :authenticate_user!


  def create

    @dfe_response_group = DataFormEntityResponseGroup.includes(:user, event_data_form_entity_group: :event).find(params[:data_form_entity_response_group])
    @entry_pass = EventEntryPass.find_or_create(@dfe_response_group.event_data_form_entity_group.event, @dfe_response_group.user, current_user, false, false, false)
  end


  def toggle_attendance
    @entry_pass = EventEntryPass.find(params[:id])

    @entry_pass.update(attendance: !@entry_pass.attendance)
    @entry_pass.update(uninvited: (@entry_pass.attendance ? @entry_pass.uninvited : false))

    @dfe_response_group = DataFormEntityResponseGroup.find(params[:data_form_entity_response_group])

  end


  def toggle_uninvited
    @entry_pass = EventEntryPass.find(params[:id])

    @entry_pass.update(uninvited: !@entry_pass.uninvited)
    @entry_pass.update(attendance: (@entry_pass.uninvited ? true : @entry_pass.attendance))


    @dfe_response_group = DataFormEntityResponseGroup.find(params[:data_form_entity_response_group])

  end


  def auto_attendance
    @event = Event.find(params[:event])
  end


  def mark_attendance

    @entry_pass = EventEntryPass.find_by(unique_code: params[:unique_code], event_id: params[:event])

    @already_marked = @entry_pass.attendance

    if !@already_marked
      @entry_pass.update(attendance: true)
    end

    if (@entry_pass.blank?)
      return error_response(
          ErrorNotification::ResponseTypes::JS,
          ErrorNotification::ErrorCodes::NOT_FOUND,
          "Please Enter Correct Code"
      )
    end


  end





end