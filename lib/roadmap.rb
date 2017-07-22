module Roadmap

  def get_roadmap(roadmap_id)
    roadmap = self.class.get(
      "/roadmaps/#{roadmap_id}",
      headers:{
          :content_type => 'application/json',
          :authorization => @auth_token
      })

    @roadmap_data = JSON.parse(roadmap.body)
  end

  def get_checkpoint(checkpoint_id)

    checkpoint = self.class.get(
      "/checkpoints/#{checkpoint_id}",
      headers:{
          :content_type => 'application/json',
          :authorization => @auth_token
      })

    @checkpoint = JSON.parse(checkpoint.body)
  end

end
