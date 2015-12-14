# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20151105175319) do

  create_table "abuse_reports", :force => true do |t|
    t.integer  "reporter_id"
    t.integer  "abuse_complaint_id"
    t.text     "content"
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "action_tracker", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_type",      :limit => nil
    t.integer  "target_id"
    t.string   "target_type",    :limit => nil
    t.text     "params"
    t.string   "verb",           :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count",                :default => 0
    t.boolean  "visible",                       :default => true
  end

  add_index "action_tracker", ["target_id", "target_type"], :name => "index_action_tracker_on_dispatcher_id_and_dispatcher_type"
  add_index "action_tracker", ["user_id", "user_type"], :name => "index_action_tracker_on_user_id_and_user_type"
  add_index "action_tracker", ["verb"], :name => "index_action_tracker_on_verb"

  create_table "action_tracker_notifications", :force => true do |t|
    t.integer "action_tracker_id"
    t.integer "profile_id"
  end

  add_index "action_tracker_notifications", ["action_tracker_id"], :name => "index_action_tracker_notifications_on_action_tracker_id"
  add_index "action_tracker_notifications", ["profile_id", "action_tracker_id"], :name => "index_action_tracker_notif_on_prof_id_act_tracker_id", :unique => true
  add_index "action_tracker_notifications", ["profile_id"], :name => "index_action_tracker_notifications_on_profile_id"

  create_table "article_followers", :force => true do |t|
    t.integer  "person_id",  :null => false
    t.integer  "article_id", :null => false
    t.datetime "since"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "article_followers", ["article_id"], :name => "index_article_followers_on_article_id"
  add_index "article_followers", ["person_id", "article_id"], :name => "index_article_followers_on_person_id_and_article_id", :unique => true
  add_index "article_followers", ["person_id"], :name => "index_article_followers_on_person_id"

  create_table "article_privacy_exceptions", :id => false, :force => true do |t|
    t.integer "article_id"
    t.integer "person_id"
  end

  create_table "article_versions", :force => true do |t|
    t.integer  "article_id"
    t.integer  "version"
    t.string   "name",                 :limit => nil
    t.string   "slug",                 :limit => nil
    t.text     "path",                                :default => ""
    t.integer  "parent_id"
    t.text     "body"
    t.text     "abstract"
    t.integer  "profile_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "last_changed_by_id"
    t.integer  "size"
    t.string   "content_type",         :limit => nil
    t.string   "filename",             :limit => nil
    t.integer  "height"
    t.integer  "width"
    t.string   "versioned_type",       :limit => nil
    t.integer  "comments_count"
    t.boolean  "advertise",                           :default => true
    t.boolean  "published",                           :default => true
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "children_count",                      :default => 0
    t.boolean  "accept_comments",                     :default => true
    t.integer  "reference_article_id"
    t.text     "setting"
    t.boolean  "notify_comments",                     :default => false
    t.integer  "hits",                                :default => 0
    t.datetime "published_at"
    t.string   "source",               :limit => nil
    t.boolean  "highlighted",                         :default => false
    t.string   "external_link",        :limit => nil
    t.boolean  "thumbnails_processed",                :default => false
    t.boolean  "is_image",                            :default => false
    t.integer  "translation_of_id"
    t.string   "language",             :limit => nil
    t.string   "source_name",          :limit => nil
    t.integer  "license_id"
    t.integer  "image_id"
    t.integer  "position"
    t.integer  "spam_comments_count",                 :default => 0
    t.integer  "author_id"
    t.integer  "created_by_id"
    t.integer  "followers_count"
  end

  add_index "article_versions", ["article_id"], :name => "index_article_versions_on_article_id"
  add_index "article_versions", ["parent_id"], :name => "index_article_versions_on_parent_id"
  add_index "article_versions", ["path", "profile_id"], :name => "index_article_versions_on_path_and_profile_id"
  add_index "article_versions", ["path"], :name => "index_article_versions_on_path"
  add_index "article_versions", ["published_at", "id"], :name => "index_article_versions_on_published_at_and_id"

  create_table "articles", :force => true do |t|
    t.string   "name",                 :limit => nil
    t.string   "slug",                 :limit => nil
    t.text     "path",                                :default => ""
    t.integer  "parent_id"
    t.text     "body"
    t.text     "abstract"
    t.integer  "profile_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "last_changed_by_id"
    t.integer  "version"
    t.string   "type",                 :limit => nil
    t.integer  "size"
    t.string   "content_type",         :limit => nil
    t.string   "filename",             :limit => nil
    t.integer  "height"
    t.integer  "width"
    t.integer  "comments_count",                      :default => 0
    t.boolean  "advertise",                           :default => true
    t.boolean  "published",                           :default => true
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "children_count",                      :default => 0
    t.boolean  "accept_comments",                     :default => true
    t.integer  "reference_article_id"
    t.text     "setting"
    t.boolean  "notify_comments",                     :default => true
    t.integer  "hits",                                :default => 0
    t.datetime "published_at"
    t.string   "source",               :limit => nil
    t.boolean  "highlighted",                         :default => false
    t.string   "external_link",        :limit => nil
    t.boolean  "thumbnails_processed",                :default => false
    t.boolean  "is_image",                            :default => false
    t.integer  "translation_of_id"
    t.string   "language",             :limit => nil
    t.string   "source_name",          :limit => nil
    t.integer  "license_id"
    t.integer  "image_id"
    t.integer  "position"
    t.integer  "spam_comments_count",                 :default => 0
    t.integer  "author_id"
    t.integer  "created_by_id"
    t.boolean  "show_to_followers",                   :default => true
    t.integer  "sash_id"
    t.integer  "level",                               :default => 0
    t.integer  "followers_count",                     :default => 0
  end

  add_index "articles", ["comments_count"], :name => "index_articles_on_comments_count"
  add_index "articles", ["created_at"], :name => "index_articles_on_created_at"
  add_index "articles", ["hits"], :name => "index_articles_on_hits"
  add_index "articles", ["name"], :name => "index_articles_on_name"
  add_index "articles", ["parent_id"], :name => "index_articles_on_parent_id"
  add_index "articles", ["path", "profile_id"], :name => "index_articles_on_path_and_profile_id"
  add_index "articles", ["path"], :name => "index_articles_on_path"
  add_index "articles", ["profile_id"], :name => "index_articles_on_profile_id"
  add_index "articles", ["published_at", "id"], :name => "index_articles_on_published_at_and_id"
  add_index "articles", ["slug"], :name => "index_articles_on_slug"
  add_index "articles", ["translation_of_id"], :name => "index_articles_on_translation_of_id"
  add_index "articles", ["type", "parent_id"], :name => "index_articles_on_type_and_parent_id"
  add_index "articles", ["type", "profile_id"], :name => "index_articles_on_type_and_profile_id"
  add_index "articles", ["type"], :name => "index_articles_on_type"

  create_table "articles_categories", :id => false, :force => true do |t|
    t.integer "article_id"
    t.integer "category_id"
    t.boolean "virtual",     :default => false
  end

  add_index "articles_categories", ["article_id"], :name => "index_articles_categories_on_article_id"
  add_index "articles_categories", ["category_id"], :name => "index_articles_categories_on_category_id"

  create_table "badges_sashes", :force => true do |t|
    t.integer  "badge_id"
    t.integer  "sash_id"
    t.boolean  "notified_user", :default => false
    t.datetime "created_at"
  end

  add_index "badges_sashes", ["badge_id", "sash_id"], :name => "index_badges_sashes_on_badge_id_and_sash_id"
  add_index "badges_sashes", ["badge_id"], :name => "index_badges_sashes_on_badge_id"
  add_index "badges_sashes", ["sash_id"], :name => "index_badges_sashes_on_sash_id"

  create_table "blocks", :force => true do |t|
    t.string   "title",           :limit => nil
    t.integer  "box_id"
    t.string   "type",            :limit => nil
    t.text     "settings"
    t.integer  "position"
    t.boolean  "enabled",                        :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "fetched_at"
    t.boolean  "mirror",                         :default => false
    t.integer  "mirror_block_id"
    t.integer  "observers_id"
  end

  add_index "blocks", ["box_id"], :name => "index_blocks_on_box_id"
  add_index "blocks", ["enabled"], :name => "index_blocks_on_enabled"
  add_index "blocks", ["fetched_at"], :name => "index_blocks_on_fetched_at"
  add_index "blocks", ["type"], :name => "index_blocks_on_type"

  create_table "boxes", :force => true do |t|
    t.string  "owner_type", :limit => nil
    t.integer "owner_id"
    t.integer "position"
  end

  add_index "boxes", ["owner_id", "owner_type"], :name => "index_boxes_on_owner_type_and_owner_id"

  create_table "categories", :force => true do |t|
    t.string  "name",            :limit => nil
    t.string  "slug",            :limit => nil
    t.text    "path",                           :default => ""
    t.integer "environment_id"
    t.integer "parent_id"
    t.string  "type",            :limit => nil
    t.float   "lat"
    t.float   "lng"
    t.boolean "display_in_menu",                :default => false
    t.integer "children_count",                 :default => 0
    t.boolean "accept_products",                :default => true
    t.integer "image_id"
    t.string  "acronym",         :limit => nil
    t.string  "abbreviation",    :limit => nil
    t.string  "display_color",   :limit => 6
    t.text    "ancestry"
  end

  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"

  create_table "categories_profiles", :id => false, :force => true do |t|
    t.integer "profile_id"
    t.integer "category_id"
    t.boolean "virtual",     :default => false
  end

  add_index "categories_profiles", ["category_id"], :name => "index_categories_profiles_on_category_id"
  add_index "categories_profiles", ["profile_id"], :name => "index_categories_profiles_on_profile_id"

  create_table "certifiers", :force => true do |t|
    t.string   "name",           :limit => nil, :null => false
    t.text     "description"
    t.string   "link",           :limit => nil
    t.integer  "environment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chat_messages", :force => true do |t|
    t.integer  "from_id",    :null => false
    t.integer  "to_id",      :null => false
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "chat_messages", ["created_at"], :name => "index_chat_messages_on_created_at"
  add_index "chat_messages", ["from_id"], :name => "index_chat_messages_on_from_id"
  add_index "chat_messages", ["to_id"], :name => "index_chat_messages_on_to_id"

  create_table "comments", :force => true do |t|
    t.string   "title",          :limit => nil
    t.text     "body"
    t.integer  "source_id"
    t.integer  "author_id"
    t.string   "name",           :limit => nil
    t.string   "email",          :limit => nil
    t.datetime "created_at"
    t.integer  "reply_of_id"
    t.string   "ip_address",     :limit => nil
    t.boolean  "spam"
    t.string   "source_type",    :limit => nil
    t.string   "user_agent",     :limit => nil
    t.string   "referrer",       :limit => nil
    t.text     "settings"
    t.integer  "paragraph_id"
    t.string   "paragraph_uuid", :limit => nil
  end

  add_index "comments", ["paragraph_uuid"], :name => "index_comments_on_paragraph_uuid"
  add_index "comments", ["source_id", "spam"], :name => "index_comments_on_source_id_and_spam"

  create_table "contact_lists", :force => true do |t|
    t.text     "list"
    t.string   "error_fetching", :limit => nil
    t.boolean  "fetched",                       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custom_field_values", :force => true do |t|
    t.string   "customized_type", :limit => nil, :default => "",    :null => false
    t.integer  "customized_id",                  :default => 0,     :null => false
    t.boolean  "public",                         :default => false, :null => false
    t.integer  "custom_field_id",                :default => 0,     :null => false
    t.text     "value",                          :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_field_values", ["customized_type", "customized_id", "custom_field_id"], :name => "index_custom_field_values", :unique => true

  create_table "custom_fields", :force => true do |t|
    t.string   "name",            :limit => nil
    t.string   "format",          :limit => nil, :default => ""
    t.text     "default_value",                  :default => ""
    t.string   "customized_type", :limit => nil
    t.text     "extras",                         :default => ""
    t.boolean  "active",                         :default => false
    t.boolean  "required",                       :default => false
    t.boolean  "signup",                         :default => false
    t.integer  "environment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_fields", ["customized_type", "name", "environment_id"], :name => "index_custom_field", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",                  :default => 0
    t.integer  "attempts",                  :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue",      :limit => nil
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "domains", :force => true do |t|
    t.string  "name",            :limit => nil
    t.string  "owner_type",      :limit => nil
    t.integer "owner_id"
    t.boolean "is_default",                     :default => false
    t.string  "google_maps_key", :limit => nil
  end

  add_index "domains", ["is_default"], :name => "index_domains_on_is_default"
  add_index "domains", ["name"], :name => "index_domains_on_name"
  add_index "domains", ["owner_id", "owner_type", "is_default"], :name => "index_domains_on_owner_id_and_owner_type_and_is_default"
  add_index "domains", ["owner_id", "owner_type"], :name => "index_domains_on_owner_id_and_owner_type"

  create_table "email_templates", :force => true do |t|
    t.string   "name"
    t.string   "template_type"
    t.string   "subject"
    t.text     "body"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "environments", :force => true do |t|
    t.string   "name",                         :limit => nil
    t.string   "contact_email",                :limit => nil
    t.boolean  "is_default"
    t.text     "settings"
    t.text     "design_data"
    t.text     "custom_header"
    t.text     "custom_footer"
    t.string   "theme",                        :limit => nil, :default => "default",              :null => false
    t.text     "terms_of_use_acceptance_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reports_lower_bound",                         :default => 0,                      :null => false
    t.string   "redirection_after_login",      :limit => nil, :default => "keep_on_same_page"
    t.text     "signup_welcome_text"
    t.string   "languages",                    :limit => nil
    t.string   "default_language",             :limit => nil
    t.string   "noreply_email",                :limit => nil
    t.string   "redirection_after_signup",     :limit => nil, :default => "keep_on_same_page"
    t.string   "date_format",                  :limit => nil, :default => "month_name_with_year"
  end

  create_table "external_feeds", :force => true do |t|
    t.string   "feed_title",    :limit => nil
    t.datetime "fetched_at"
    t.text     "address"
    t.integer  "blog_id",                                        :null => false
    t.boolean  "enabled",                      :default => true, :null => false
    t.boolean  "only_once",                    :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "error_message"
    t.integer  "update_errors",                :default => 0
  end

  add_index "external_feeds", ["blog_id"], :name => "index_external_feeds_on_blog_id"
  add_index "external_feeds", ["enabled"], :name => "index_external_feeds_on_enabled"
  add_index "external_feeds", ["fetched_at"], :name => "index_external_feeds_on_fetched_at"

  create_table "favorite_enterprise_people", :force => true do |t|
    t.integer  "person_id"
    t.integer  "enterprise_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorite_enterprise_people", ["enterprise_id"], :name => "index_favorite_enterprise_people_on_enterprise_id"
  add_index "favorite_enterprise_people", ["person_id", "enterprise_id"], :name => "index_favorite_enterprise_people_on_person_id_and_enterprise_id"
  add_index "favorite_enterprise_people", ["person_id"], :name => "index_favorite_enterprise_people_on_person_id"

  create_table "friendships", :force => true do |t|
    t.integer  "person_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.string   "group",      :limit => nil
  end

  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["person_id", "friend_id"], :name => "index_friendships_on_person_id_and_friend_id"
  add_index "friendships", ["person_id"], :name => "index_friendships_on_person_id"

  create_table "gamification_plugin_badges", :force => true do |t|
    t.string   "name"
    t.integer  "level"
    t.string   "description"
    t.text     "custom_fields"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "title"
  end

  create_table "gamification_plugin_points_categorizations", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "point_type_id"
    t.integer  "weight"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "gamification_plugin_points_categorizations", ["point_type_id"], :name => "index_points_categorizations_on_point_type_id"
  add_index "gamification_plugin_points_categorizations", ["profile_id"], :name => "index_gamification_plugin_points_categorizations_on_profile_id"

  create_table "gamification_plugin_points_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "images", :force => true do |t|
    t.integer "parent_id"
    t.string  "content_type",         :limit => nil
    t.string  "filename",             :limit => nil
    t.string  "thumbnail",            :limit => nil
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.boolean "thumbnails_processed",                :default => false
    t.string  "label",                :limit => nil, :default => ""
  end

  add_index "images", ["parent_id"], :name => "index_images_on_parent_id"

  create_table "inputs", :force => true do |t|
    t.integer  "product_id",                                    :null => false
    t.integer  "product_category_id",                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.decimal  "price_per_unit"
    t.decimal  "amount_used"
    t.boolean  "relevant_to_price",          :default => true
    t.boolean  "is_from_solidarity_economy", :default => false
    t.integer  "unit_id"
  end

  add_index "inputs", ["product_category_id"], :name => "index_inputs_on_product_category_id"
  add_index "inputs", ["product_id"], :name => "index_inputs_on_product_id"

  create_table "licenses", :force => true do |t|
    t.string  "name",           :limit => nil, :null => false
    t.string  "slug",           :limit => nil, :null => false
    t.string  "url",            :limit => nil
    t.integer "environment_id",                :null => false
  end

  create_table "mailing_sents", :force => true do |t|
    t.integer  "mailing_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailings", :force => true do |t|
    t.string   "type",        :limit => nil
    t.string   "subject",     :limit => nil
    t.text     "body"
    t.integer  "source_id"
    t.string   "source_type", :limit => nil
    t.integer  "person_id"
    t.string   "locale",      :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merit_actions", :force => true do |t|
    t.integer  "user_id"
    t.string   "action_method"
    t.integer  "action_value"
    t.boolean  "had_errors",    :default => false
    t.string   "target_model"
    t.integer  "target_id"
    t.text     "target_data"
    t.boolean  "processed",     :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "merit_activity_logs", :force => true do |t|
    t.integer  "action_id"
    t.string   "related_change_type"
    t.integer  "related_change_id"
    t.string   "description"
    t.datetime "created_at"
  end

  create_table "merit_score_points", :force => true do |t|
    t.integer  "score_id"
    t.integer  "num_points", :default => 0
    t.string   "log"
    t.datetime "created_at"
    t.integer  "action_id"
  end

  create_table "merit_scores", :force => true do |t|
    t.integer "sash_id"
    t.string  "category", :default => "default"
  end

  create_table "national_region_types", :force => true do |t|
    t.string "name", :limit => nil
  end

  create_table "national_regions", :force => true do |t|
    t.string   "name",                        :limit => nil
    t.string   "national_region_code",        :limit => nil
    t.string   "parent_national_region_code", :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "national_region_type_id"
  end

  add_index "national_regions", ["name"], :name => "name_index"
  add_index "national_regions", ["national_region_code"], :name => "code_index"

  create_table "price_details", :force => true do |t|
    t.decimal  "price",              :default => 0.0
    t.integer  "product_id"
    t.integer  "production_cost_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_qualifiers", :force => true do |t|
    t.integer  "product_id"
    t.integer  "qualifier_id"
    t.integer  "certifier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_qualifiers", ["certifier_id"], :name => "index_product_qualifiers_on_certifier_id"
  add_index "product_qualifiers", ["product_id"], :name => "index_product_qualifiers_on_product_id"
  add_index "product_qualifiers", ["qualifier_id"], :name => "index_product_qualifiers_on_qualifier_id"

  create_table "production_costs", :force => true do |t|
    t.string   "name",       :limit => nil
    t.integer  "owner_id"
    t.string   "owner_type", :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "product_category_id"
    t.string   "name",                :limit => nil
    t.decimal  "price"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "discount"
    t.boolean  "available",                          :default => true
    t.boolean  "highlighted",                        :default => false
    t.integer  "unit_id"
    t.integer  "image_id"
    t.string   "type",                :limit => nil
    t.text     "data"
    t.boolean  "archived",                           :default => false
  end

  add_index "products", ["created_at"], :name => "index_products_on_created_at"
  add_index "products", ["product_category_id"], :name => "index_products_on_product_category_id"
  add_index "products", ["profile_id"], :name => "index_products_on_profile_id"

  create_table "profile_activities", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "activity_id"
    t.string   "activity_type", :limit => nil
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "profile_activities", ["activity_id", "activity_type"], :name => "index_profile_activities_on_activity_id_and_activity_type"
  add_index "profile_activities", ["activity_type"], :name => "index_profile_activities_on_activity_type"
  add_index "profile_activities", ["profile_id"], :name => "index_profile_activities_on_profile_id"

  create_table "profile_suggestions", :force => true do |t|
    t.integer  "person_id"
    t.integer  "suggestion_id"
    t.string   "suggestion_type", :limit => nil
    t.text     "categories"
    t.boolean  "enabled",                        :default => true
    t.float    "score",                          :default => 0.0
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "profile_suggestions", ["person_id"], :name => "index_profile_suggestions_on_person_id"
  add_index "profile_suggestions", ["score"], :name => "index_profile_suggestions_on_score"
  add_index "profile_suggestions", ["suggestion_id"], :name => "index_profile_suggestions_on_suggestion_id"

  create_table "profiles", :force => true do |t|
    t.string   "name",                    :limit => nil
    t.string   "type",                    :limit => nil
    t.string   "identifier",              :limit => nil
    t.integer  "environment_id"
    t.boolean  "active",                                 :default => true
    t.string   "address",                 :limit => nil
    t.string   "contact_phone",           :limit => nil
    t.integer  "home_page_id"
    t.integer  "user_id"
    t.integer  "region_id"
    t.text     "data"
    t.datetime "created_at"
    t.float    "lat"
    t.float    "lng"
    t.integer  "geocode_precision"
    t.boolean  "enabled",                                :default => true
    t.string   "nickname",                :limit => 16
    t.text     "custom_header"
    t.text     "custom_footer"
    t.string   "theme",                   :limit => nil
    t.boolean  "public_profile",                         :default => true
    t.date     "birth_date"
    t.integer  "preferred_domain_id"
    t.datetime "updated_at"
    t.boolean  "visible",                                :default => true
    t.integer  "image_id"
    t.boolean  "validated",                              :default => true
    t.string   "cnpj",                    :limit => nil
    t.string   "national_region_code",    :limit => nil
    t.boolean  "is_template",                            :default => false
    t.integer  "template_id"
    t.string   "redirection_after_login", :limit => nil
    t.integer  "friends_count",                          :default => 0,     :null => false
    t.integer  "members_count",                          :default => 0,     :null => false
    t.integer  "activities_count",                       :default => 0,     :null => false
    t.string   "personal_website",        :limit => nil
    t.string   "jabber_id",               :limit => nil
    t.integer  "welcome_page_id"
    t.boolean  "allow_members_to_invite",                :default => true
    t.boolean  "invite_friends_only",                    :default => false
    t.boolean  "secret",                                 :default => false
    t.integer  "sash_id"
    t.integer  "level",                                  :default => 0
  end

  add_index "profiles", ["activities_count"], :name => "index_profiles_on_activities_count"
  add_index "profiles", ["created_at"], :name => "index_profiles_on_created_at"
  add_index "profiles", ["environment_id"], :name => "index_profiles_on_environment_id"
  add_index "profiles", ["friends_count"], :name => "index_profiles_on_friends_count"
  add_index "profiles", ["identifier"], :name => "index_profiles_on_identifier"
  add_index "profiles", ["members_count"], :name => "index_profiles_on_members_count"
  add_index "profiles", ["region_id"], :name => "index_profiles_on_region_id"
  add_index "profiles", ["user_id", "type"], :name => "index_profiles_on_user_id_and_type"
  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "proposals_discussion_plugin_proposal_evaluations", :force => true do |t|
    t.integer  "proposal_task_id"
    t.integer  "evaluator_id"
    t.integer  "flagged_status"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "proposals_discussion_plugin_proposal_evaluations", ["evaluator_id"], :name => "index_proposals_discussion_plugin_proposal_evaluator_id"
  add_index "proposals_discussion_plugin_proposal_evaluations", ["proposal_task_id"], :name => "index_proposals_discussion_plugin_proposal_task_id"

  create_table "proposals_discussion_plugin_ranking_items", :force => true do |t|
    t.integer  "position"
    t.string   "abstract"
    t.integer  "votes_for"
    t.integer  "votes_against"
    t.integer  "hits"
    t.decimal  "effective_support"
    t.integer  "proposal_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "proposals_discussion_plugin_ranking_items", ["proposal_id"], :name => "index_proposals_discussion_plugin_ranking_proposal_id"

  create_table "proposals_discussion_plugin_task_categories", :id => false, :force => true do |t|
    t.integer "task_id"
    t.integer "category_id"
  end

  create_table "qualifier_certifiers", :force => true do |t|
    t.integer "qualifier_id"
    t.integer "certifier_id"
  end

  create_table "qualifiers", :force => true do |t|
    t.string   "name",           :limit => nil, :null => false
    t.integer  "environment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refused_join_community", :id => false, :force => true do |t|
    t.integer "person_id"
    t.integer "community_id"
  end

  create_table "region_validators", :id => false, :force => true do |t|
    t.integer "region_id"
    t.integer "organization_id"
  end

  create_table "reported_images", :force => true do |t|
    t.integer "size"
    t.string  "content_type",    :limit => nil
    t.string  "filename",        :limit => nil
    t.integer "height"
    t.integer "width"
    t.integer "abuse_report_id"
  end

  create_table "role_assignments", :force => true do |t|
    t.integer "accessor_id",                  :null => false
    t.string  "accessor_type", :limit => nil
    t.integer "resource_id"
    t.string  "resource_type", :limit => nil
    t.integer "role_id",                      :null => false
    t.boolean "is_global"
  end

  create_table "roles", :force => true do |t|
    t.string  "name",           :limit => nil
    t.string  "key",            :limit => nil
    t.boolean "system",                        :default => false
    t.text    "permissions"
    t.integer "environment_id"
    t.integer "profile_id"
  end

  create_table "sashes", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "scraps", :force => true do |t|
    t.text     "content"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.integer  "scrap_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "context_id"
  end

  create_table "search_term_occurrences", :force => true do |t|
    t.integer  "search_term_id"
    t.datetime "created_at"
    t.integer  "total",          :default => 0
    t.integer  "indexed",        :default => 0
  end

  add_index "search_term_occurrences", ["created_at"], :name => "index_search_term_occurrences_on_created_at"

  create_table "search_terms", :force => true do |t|
    t.string  "term",             :limit => nil
    t.integer "context_id"
    t.string  "context_type",     :limit => nil
    t.string  "asset",            :limit => nil, :default => "all"
    t.float   "score",                           :default => 0.0
    t.float   "relevance_score",                 :default => 0.0
    t.float   "occurrence_score",                :default => 0.0
  end

  add_index "search_terms", ["asset"], :name => "index_search_terms_on_asset"
  add_index "search_terms", ["occurrence_score"], :name => "index_search_terms_on_occurrence_score"
  add_index "search_terms", ["relevance_score"], :name => "index_search_terms_on_relevance_score"
  add_index "search_terms", ["score"], :name => "index_search_terms_on_score"
  add_index "search_terms", ["term"], :name => "index_search_terms_on_term"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :limit => nil, :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"
  add_index "sessions", ["user_id"], :name => "index_sessions_on_user_id"

  create_table "suggestion_connections", :force => true do |t|
    t.integer "suggestion_id",                  :null => false
    t.integer "connection_id",                  :null => false
    t.string  "connection_type", :limit => nil, :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", :limit => nil
    t.datetime "created_at"
    t.integer  "tagger_id"
    t.string   "tagger_type",   :limit => nil
    t.string   "context",       :limit => 128
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], :name => "taggings_idx", :unique => true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string  "name",           :limit => nil
    t.integer "parent_id"
    t.boolean "pending",                       :default => false
    t.integer "taggings_count",                :default => 0
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true
  add_index "tags", ["parent_id"], :name => "index_tags_on_parent_id"

  create_table "tasks", :force => true do |t|
    t.text     "data"
    t.integer  "status"
    t.datetime "end_date"
    t.integer  "requestor_id"
    t.integer  "target_id"
    t.string   "code",           :limit => 40
    t.string   "type",           :limit => nil
    t.datetime "created_at"
    t.string   "target_type",    :limit => nil
    t.integer  "image_id"
    t.boolean  "spam",                          :default => false
    t.integer  "responsible_id"
    t.integer  "closed_by_id"
  end

  add_index "tasks", ["requestor_id"], :name => "index_tasks_on_requestor_id"
  add_index "tasks", ["spam"], :name => "index_tasks_on_spam"
  add_index "tasks", ["status"], :name => "index_tasks_on_status"
  add_index "tasks", ["target_id", "target_type"], :name => "index_tasks_on_target_id_and_target_type"
  add_index "tasks", ["target_id"], :name => "index_tasks_on_target_id"
  add_index "tasks", ["target_type"], :name => "index_tasks_on_target_type"

  create_table "terms_forum_people", :id => false, :force => true do |t|
    t.integer "forum_id"
    t.integer "person_id"
  end

  add_index "terms_forum_people", ["forum_id", "person_id"], :name => "index_terms_forum_people_on_forum_id_and_person_id"

  create_table "thumbnails", :force => true do |t|
    t.integer "size"
    t.string  "content_type", :limit => nil
    t.string  "filename",     :limit => nil
    t.integer "height"
    t.integer "width"
    t.integer "parent_id"
    t.string  "thumbnail",    :limit => nil
  end

  add_index "thumbnails", ["parent_id"], :name => "index_thumbnails_on_parent_id"

  create_table "units", :force => true do |t|
    t.string  "singular",       :limit => nil, :null => false
    t.string  "plural",         :limit => nil, :null => false
    t.integer "position"
    t.integer "environment_id",                :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login",                      :limit => nil
    t.string   "email",                      :limit => nil
    t.string   "crypted_password",           :limit => 40
    t.string   "salt",                       :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",             :limit => nil
    t.datetime "remember_token_expires_at"
    t.text     "terms_of_use"
    t.string   "terms_accepted",             :limit => 1
    t.integer  "environment_id"
    t.string   "password_type",              :limit => nil
    t.boolean  "enable_email",                              :default => false
    t.string   "last_chat_status",           :limit => nil, :default => ""
    t.string   "chat_status",                :limit => nil, :default => ""
    t.datetime "chat_status_at"
    t.string   "activation_code",            :limit => 40
    t.datetime "activated_at"
    t.string   "return_to",                  :limit => nil
    t.datetime "last_login_at"
    t.string   "private_token",              :limit => nil
    t.datetime "private_token_generated_at"
  end

  create_table "validation_infos", :force => true do |t|
    t.text    "validation_methodology"
    t.text    "restrictions"
    t.integer "organization_id"
  end

  create_table "votes", :force => true do |t|
    t.integer  "vote",                         :null => false
    t.integer  "voteable_id",                  :null => false
    t.string   "voteable_type", :limit => nil, :null => false
    t.integer  "voter_id"
    t.string   "voter_type",    :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "fk_voteables"
  add_index "votes", ["voter_id", "voter_type"], :name => "fk_voters"

end
