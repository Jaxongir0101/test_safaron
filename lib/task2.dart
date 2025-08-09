List<(int, int, int)> threeSum(List<int> nums) {
  nums.sort();
  final result = <(int, int, int)>[];

  for (int i = 0; i < nums.length - 2; i++) {
    if (i > 0 && nums[i] == nums[i - 1]) continue; // Пропуск дубликатов

    int left = i + 1;
    int right = nums.length - 1;

    while (left < right) {
      int sum = nums[i] + nums[left] + nums[right];

      if (sum == 0) {
        result.add((nums[i], nums[left], nums[right]));

        // Пропуск одинаковых left
        while (left < right && nums[left] == nums[left + 1]) left++;
        // Пропуск одинаковых right
        while (left < right && nums[right] == nums[right - 1]) right--;

        left++;
        right--;
      } else if (sum < 0) {
        left++;
      } else {
        right--;
      }
    }
  }

  return result;
}

void main() {
  print(threeSum([-1, 0, 1, 2, -1, -4]));
  // Вывод: [(-1, -1, 2), (-1, 0, 1)]
}
