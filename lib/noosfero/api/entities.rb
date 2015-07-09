module Noosfero
  module API
    module Entities

      Entity.format_with :timestamp do |date|
        date.strftime('%Y/%m/%d %H:%M:%S') if date
      end

      class Image < Entity
        root 'images', 'image'

        expose  :url do |image, options|
          image.public_filename
        end

        expose  :icon_url do |image, options|
          image.public_filename(:icon)
        end

        expose  :minor_url do |image, options|
          image.public_filename(:minor)
        end

        expose  :portrait_url do |image, options|
          image.public_filename(:portrait)
        end

        expose  :thumb_url do |image, options|
          image.public_filename(:thumb)
        end
      end

      class Profile < Entity
        expose :identifier, :name, :id
        expose :created_at, :format_with => :timestamp
        expose :image, :using => Image
      end

      class UserBasic < Entity
        expose :id
        expose :login
      end

      class Person < Profile
        root 'people', 'person'
        expose :user, :using => UserBasic
      end

      class Enterprise < Profile
        root 'enterprises', 'enterprise'
      end
      
      class Community < Profile
        root 'communities', 'community'
        expose :description
      end

      class CategoryBase < Entity
        root 'categories', 'category'
        expose :name, :id, :slug
      end

      class Category < CategoryBase
        root 'categories', 'category'
        expose :full_name do |category, options|
          category.full_name
        end
        expose :parent, :using => CategoryBase, if: { parent: true }
        expose :children, :using => CategoryBase, if: { children: true }
        expose :image, :using => Image
      end

      class ArticleBase < Entity
        root 'articles', 'article'
        expose :id
        expose :body
        expose :abstract
        expose :created_at, :format_with => :timestamp
        expose :title, :documentation => {:type => "String", :desc => "Title of the article"}
        expose :created_by, :as => :author, :using => Profile
        expose :profile, :using => Profile
        expose :categories, :using => Category
        expose :image, :using => Image
        #TODO Apply vote stuff in core and make this test
        expose :votes_for
        expose :votes_against
        expose :setting
        expose :position
        expose :hits
        expose :start_date
        expose :end_date
        expose :tag_list
      end

      class Article < ArticleBase
        root 'articles', 'article'
        expose :parent, :using => ArticleBase
        expose :children, :using => ArticleBase
      end

      class Comment < Entity
        root 'comments', 'comment'
        expose :body, :title, :id
        expose :created_at, :format_with => :timestamp
        expose :author, :using => Profile
      end


      class User < Entity
        root 'users', 'user'
        expose :id
        expose :login
        expose :person, :using => Profile
        expose :permissions do |user, options|
          output = {}
          user.person.role_assignments.map do |role_assigment|
            if role_assigment.resource.respond_to?(:identifier)
              output[role_assigment.resource.identifier] = role_assigment.role.permissions
            end
          end
          output
        end
      end

      class UserLogin < User
        expose :private_token
      end

      class Task < Entity
        root 'tasks', 'task'
        expose :id
        expose :type
      end

      class Environment < Entity
        expose :name
      end

      class Tag < Entity
        root 'tags', 'tag'
        expose :name
      end


    end
  end
end
