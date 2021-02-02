package com.project.hunsu.service;

import com.project.hunsu.model.entity.Follower;
import com.project.hunsu.model.entity.User;
import com.project.hunsu.repository.UserRepository;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;

@Service
public class UserService {

    private final UserRepository userRepository;
    @PersistenceContext
    EntityManager entityManager;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Transactional
    public void followAdd(String myNickname, String yourNickname) {
        User user = entityManager.find(User.class, myNickname);
        Follower follower = new Follower();
        follower.setUser(user);
        follower.setFollowTo(yourNickname);
        entityManager.persist(follower);
    }


    @Transactional
    public void followDelete(String myNickname, String yourNickname) {
        String query = " delete from Follower where followTo = : yourNickname";
        int result = entityManager.createQuery(query).setParameter("yourNickname",yourNickname).executeUpdate();
    }


}