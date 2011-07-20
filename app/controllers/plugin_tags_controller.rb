class PluginTagsController < ApplicationController
  def create
     @tag = PluginTag.new
     @tag.name = params[:tag_name]
     @tag.user_id = @logged_in_user.id
     @tag.item_id = @item.id
     @tag.is_approved = "1" if !@group_permissions_for_plugin.requires_approval? || @item.is_user_owner?(@logged_in_user) || @logged_in_user.is_admin? # approve if not required or owner or admin 
     
     if @tag.save
       Log.create(:user_id => @logged_in_user.id, :item_id => @item.id,  :log_type => "new", :log => t("log.item_create", :item => @plugin.model_name.human, :name => @tag.name))                                              
       flash[:success] = t("notice.item_create_success", :item => @plugin.model_name.human)
       flash[:notice] += "<br>" + t("notice.item_needs_approval", :item => @plugin.model_name.human) if !@tag.is_approved?     
     else # fail saved 
       flash[:failure] = t("notice.item_create_failure", :item => @plugin.model_name.human)
     end     
     redirect_to :action => "view", :controller => "items", :id => @item.id, :anchor => @plugin.model_name.human(:count => :other) 
  end
  
  def delete
     @tag = PluginTag.find(params[:tag_id])
     if @tag.destroy
      Log.create(:user_id => @logged_in_user.id, :item_id => @item.id,  :log_type => "delete", :log => t("log.item_delete", :item => @plugin.model_name.human, :name => @tag.name))                                                     
      flash[:success] = t("notice.item_delete_success", :item => @plugin.model_name.human)
     else # fail saved 
       flash[:failure] = t("notice.item_delete_failure", :item => @plugin.model_name.human)
     end     
     redirect_to :action => "view", :controller => "items", :id => @item.id, :anchor => @plugin.model_name.human(:count => :other) 
  end

 
  def change_approval
    @tag = PluginTag.find(params[:tag_id])    
    if  @tag.is_approved?
      approval = "0" # set to unapproved if approved already    
      log_msg = t("log.item_unapprove", :item => @plugin.model_name.human, :name => @tag.name)
    else
      approval = "1" # set to approved if unapproved already    
      log_msg = t("log.item_approve", :item => @plugin.model_name.human, :name => @tag.name)
    end
    
    if @tag.update_attribute(:is_approved, approval)
      Log.create(:user_id => @logged_in_user.id, :item_id => @item.id,  :log_type => "update", :log => log_msg)      
      flash[:success] = t("notice.item_#{"un" if approval == "0"}approve_success", :item => @plugin.model_name.human)  
    else
      flash[:failure] =  t("notice.item_save_failure", :item => @plugin.model_name.human) 
    end
    redirect_to :action => "view", :controller => "items", :id => @item.id, :anchor => @plugin.model_name.human(:count => :other) 
  end 
end
