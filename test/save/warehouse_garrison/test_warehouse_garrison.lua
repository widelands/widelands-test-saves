run(function()
   sleep(2000)

   local hqs = p1:get_buildings("barbarians_headquarters")
   assert_equal(1, #hqs)
   local hq = hqs[1]
   local fhq = hq.flag

   assert_equal(11, hq:get_workers("barbarians_soldier"))

   hq.soldier_preference = "heroes"
   hq.garrison = 10  -- one free soldier

   -- Connect sentry to HQ, the weakest soldier should occupy the sentry
   print("Allowing only the weakest soldier to the sentry")
   sentry.soldier_preference = "heroes"
   connected_road("normal", p1, fhq, "r,r|", true)

   game.desired_speed = 20000

   while sentry:get_soldiers("present") ~= 1 do
      sleep(1000)
   end
   sleep(1000)

   assert_equal(10, hq:get_workers("barbarians_soldier"))
   assert_equal(1, sentry:get_soldiers("associated"))
   assert_equal(1, sentry:get_soldiers{0, 0, 0, 0}, "Not the weakest soldier occupied the sentry")

   -- Free up more soldiers
   print("Allow stronger soldiers to the sentry")
   hq.garrison = 3

   sleep(1000)
   while sentry:get_soldiers("present") < 2 or sentry:get_soldiers("associated") > 2 do
      sleep(1000)
   end

   assert_equal(1, sentry:get_soldiers{0, 5, 0, 2}, "Expected soldier is not in the sentry")
   if sentry:get_soldiers{0, 0, 0, 0} == 1 then
      -- exchange was not triggered, let's force it
      sentry.capacity = 1
      sleep(1000)
      sentry.capacity = 2
      while sentry:get_soldiers("present") < 2 or sentry:get_soldiers("associated") > 2 do
         sleep(1000)
      end
   end

   -- make sure the soldier reached the HQ
   while hq:get_soldiers("present") < 9 do
      sleep(1000)
   end

   assert_equal(9, hq:get_soldiers("associated"))
   assert_equal(0, sentry:get_soldiers{0, 0, 0, 0}, "Weakest soldier is still in the sentry")
   assert_equal(1, sentry:get_soldiers{0, 5, 0, 2}, "Expected soldier is not in the sentry")
   assert_equal(1, sentry:get_soldiers{0, 4, 0, 2}, "Expected soldier is not in the sentry")
   assert_equal(1, hq:get_soldiers{3, 5, 0, 2}, "Expected soldier is not in the HQ")
   assert_equal(1, hq:get_soldiers{2, 5, 0, 2}, "Expected soldier is not in the HQ")
   assert_equal(1, hq:get_soldiers{1, 5, 0, 2}, "Expected soldier is not in the HQ")
   assert_equal(0, hq:get_soldiers{0, 5, 0, 2}, "Unexpected soldier is in the HQ")
   assert_equal(0, hq:get_soldiers{0, 4, 0, 2}, "Unexpected soldier is in the HQ")
   assert_equal(1, hq:get_soldiers{0, 3, 0, 2}, "Expected soldier is not in the HQ")
   assert_equal(1, hq:get_soldiers{0, 0, 0, 0}, "Expected soldier is not in the HQ")

   -- Release the strongest soldiers and force exchange
   print("Allow the strongest soldiers to the sentry")
   hq.soldier_preference = "rookies"
   sentry.capacity = 1
   sleep(1000)
   sentry.capacity = 2
   sleep(1000)

   while sentry:get_soldiers("present") < 2 or sentry:get_soldiers("associated") > 2 do
      sleep(1000)
   end

   assert_equal(1, sentry:get_soldiers{3, 5, 0, 2}, "Expected soldier is not in the sentry")
   if sentry:get_soldiers{2, 5, 0, 2} == 0 then
      -- second exchange was not triggered, let's force it
      sentry.capacity = 1
      sleep(1000)
      sentry.capacity = 2
      while sentry:get_soldiers("present") < 2 or sentry:get_soldiers("associated") > 2 do
         sleep(1000)
      end
   end

   -- make sure the soldier reached the HQ
   while hq:get_soldiers("present") < 9 do
      sleep(1000)
   end

   assert_equal(9, hq:get_soldiers("associated"))
   assert_equal(0, sentry:get_soldiers{0, 5, 0, 2}, "Unexpected soldier is in the sentry")
   assert_equal(0, sentry:get_soldiers{0, 4, 0, 2}, "Unexpected soldier is in the sentry")
   assert_equal(1, sentry:get_soldiers{3, 5, 0, 2}, "Expected soldier is not in the sentry")
   assert_equal(1, sentry:get_soldiers{2, 5, 0, 2}, "Expected soldier is not in the sentry")
   assert_equal(0, hq:get_soldiers{3, 5, 0, 2}, "Unexpected soldier is in the HQ")
   assert_equal(0, hq:get_soldiers{2, 5, 0, 2}, "Unexpected soldier is in the HQ")
   assert_equal(1, hq:get_soldiers{1, 5, 0, 2}, "Expected soldier is not in the HQ")
   assert_equal(1, hq:get_soldiers{0, 5, 0, 2}, "Expected soldier is not in the HQ")
   assert_equal(1, hq:get_soldiers{0, 4, 0, 2}, "Expected soldier is not in the HQ")

   -- Try to get the weakest ones to go to the sentry
   print("Request rookies but don't allow the weakest soldiers to the sentry")
   sentry.soldier_preference = "rookies"
   sentry.capacity = 1
   sleep(1000)
   sentry.capacity = 2
   sleep(1000)

   while sentry:get_soldiers("present") < 2 or sentry:get_soldiers("associated") > 2 do
      sleep(1000)
   end

   assert_equal(1, sentry:get_soldiers{0, 1, 0, 2}, "Expected soldier is not in the sentry")
   if sentry:get_soldiers{0, 2, 0, 2} == 0 then
      -- second exchange was not triggered, let's force it
      sentry.capacity = 1
      sleep(1000)
      sentry.capacity = 2
      while sentry:get_soldiers("present") < 2 or sentry:get_soldiers("associated") > 2 do
         sleep(1000)
      end
   end

   -- make sure the soldier reached the HQ
   while hq:get_soldiers("present") < 9 do
      sleep(1000)
   end

   assert_equal(9, hq:get_soldiers("associated"))
   assert_equal(0, sentry:get_soldiers{0, 0, 0, 0}, "Unexpected soldier is in the sentry")
   assert_equal(0, sentry:get_soldiers{3, 5, 0, 2}, "Unexpected soldier is in the sentry")
   assert_equal(1, sentry:get_soldiers{0, 1, 0, 2}, "Expected soldier is not in the sentry")
   assert_equal(1, sentry:get_soldiers{0, 2, 0, 2}, "Expected soldier is not in the sentry")
   assert_equal(1, hq:get_soldiers{3, 5, 0, 2}, "Expected soldier is not in the HQ")
   assert_equal(1, hq:get_soldiers{2, 5, 0, 2}, "Expected soldier is not in the HQ")
   assert_equal(1, hq:get_soldiers{0, 0, 0, 0}, "Expected soldier is not in the HQ")
   assert_equal(1, hq:get_soldiers{0, 0, 0, 1}, "Expected soldier is not in the HQ")
   assert_equal(1, hq:get_soldiers{0, 0, 0, 2}, "Expected soldier is not in the HQ")

   print("# All Tests passed.")
   wl.ui.MapView():close()
end)
