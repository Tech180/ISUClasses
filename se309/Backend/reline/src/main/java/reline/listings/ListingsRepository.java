package reline.listings;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ListingsRepository extends JpaRepository<Listings, Integer>, CrudRepository<Listings, Integer> {

}
