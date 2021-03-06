package com.project.hunsu.repository;

import com.project.hunsu.model.entity.Follower;
import com.project.hunsu.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface FollowerRepository extends JpaRepository<Follower,Long> {
    Follower findFollowerByMemIdAndTargetId(User memUser, User targetUser);
    List<Follower> findFollowerByMemIdAndFlag(User user, Boolean flag);
    List<Follower> findFollowerByTargetIdAndFlag(User user, Boolean flag);

}
