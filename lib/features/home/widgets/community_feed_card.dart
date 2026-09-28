import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';

class CommunityFeedCard extends StatefulWidget {
  const CommunityFeedCard({super.key});

  @override
  State<CommunityFeedCard> createState() => _CommunityFeedCardState();
}

class _CommunityFeedCardState extends State<CommunityFeedCard> {
  final Set<int> _likedPostIndices = {};
  int? _expandedCommentsIndex;
  final TextEditingController _commentController = TextEditingController();

  final List<Map<String, dynamic>> _posts = [
    {
      "type": "teaching",
      "typeLabel": "Daily Teaching",
      "typeIcon": "📖",
      "colors": const [Color(0xFF10B981), Color(0xFF0D9488)],
      "timeAgo": "2h ago",
      "source": "Imam Al-Ghazali (Ihya Ulum ad-Din)",
      "content":
          "The tongue is a small limb, but its crimes are enormous. Guarding speech from backbiting, mockery, and vanity is the first fortress of spiritual peace.",
      "likes": 42,
      "comments": [
        {"author": "Zayd M.", "text": "SubhanAllah, very timely reminder for today."},
        {"author": "Maryam K.", "text": "May Allah grant us wisdom in our words."},
      ],
    },
    {
      "type": "hadith",
      "typeLabel": "Hadith of the Day",
      "typeIcon": "📜",
      "colors": const [Color(0xFFF59E0B), Color(0xFFD97706)],
      "timeAgo": "5h ago",
      "source": "Sahih Al-Bukhari 6018",
      "content":
          "The Prophet ﷺ said: 'Do not hate one another, do not envy one another, and do not turn away from one another. Be, O servants of Allah, brothers.'",
      "likes": 89,
      "comments": [
        {"author": "Bilal T.", "text": "A beautiful principle of brotherhood and unity."},
        {"author": "Aisha R.", "text": "JazakAllahu khayran for sharing this noble hadith."},
      ],
    },
    {
      "type": "verse",
      "typeLabel": "Quranic Verse",
      "typeIcon": "✨",
      "colors": const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
      "timeAgo": "8h ago",
      "source": "Surah Ash-Sharh 94:5-6",
      "content":
          "فَإِنَّ مَعَ الْعُسْرِ يُسْرًا • إِنَّ مَعَ الْعُسْرِ يُسْرًا\n'For indeed, with hardship [will be] ease. Indeed, with hardship [will be] ease.'",
      "likes": 124,
      "comments": [
        {"author": "Tariq S.", "text": "Whenever distress intensifies, relief is imminent."},
      ],
    },
    {
      "type": "story",
      "typeLabel": "Prophet Story",
      "typeIcon": "📚",
      "colors": const [Color(0xFF6366F1), Color(0xFF4F46E5)],
      "timeAgo": "1d ago",
      "source": "Stories of the Prophets",
      "content":
          "When Prophet Yunus (AS) was in the depths of the ocean and the belly of the whale, he called out: 'La ilaha illa Anta, Subhanaka, inni kuntu minaz-zalimin.' No believer recites this in distress except that Allah relieves them.",
      "likes": 76,
      "comments": [
        {"author": "Khadijah A.", "text": "One of the greatest duas in the Holy Quran."},
      ],
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleLike(int index) {
    setState(() {
      if (_likedPostIndices.contains(index)) {
        _likedPostIndices.remove(index);
        _posts[index]["likes"] = (_posts[index]["likes"] as int) - 1;
      } else {
        _likedPostIndices.add(index);
        _posts[index]["likes"] = (_posts[index]["likes"] as int) + 1;
      }
    });
  }

  void _addComment(int postIndex) {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      (_posts[postIndex]["comments"] as List).add({
        "author": "You",
        "text": text,
      });
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.menu_book_rounded, color: AppColors.islamicIndigo, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Daily Wisdom",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Active Ummah",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Posts List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _posts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final post = _posts[index];
            final isLiked = _likedPostIndices.contains(index);
            final colors = post["colors"] as List<Color>;
            final comments = post["comments"] as List;
            final isExpanded = _expandedCommentsIndex == index;

            return Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post Top Pill & Time
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              colors.first.withOpacity(0.2),
                              colors.last.withOpacity(0.1),
                            ]),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.first.withOpacity(0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(post["typeIcon"] as String, style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 6),
                              Text(
                                post["typeLabel"] as String,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: colors.first,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          post["timeAgo"] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Post content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      post["content"] as String,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.5,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Source attribution
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "— ${post["source"]}",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),

                  // Actions row: Like, Comment, Share
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Likes
                        GestureDetector(
                          onTap: () => _toggleLike(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            child: Row(
                              children: [
                                Icon(
                                  isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  size: 18,
                                  color: isLiked ? Colors.redAccent : (isDark ? Colors.white60 : Colors.grey),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "${post["likes"]}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isLiked ? FontWeight.bold : FontWeight.w500,
                                    color: isLiked ? Colors.redAccent : (isDark ? Colors.white70 : Colors.grey[700]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Comments toggle
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _expandedCommentsIndex = isExpanded ? null : index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  size: 17,
                                  color: isExpanded ? AppColors.islamicIndigo : (isDark ? Colors.white60 : Colors.grey),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "${comments.length} comments",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isExpanded ? FontWeight.bold : FontWeight.w500,
                                    color: isExpanded ? AppColors.islamicIndigo : (isDark ? Colors.white70 : Colors.grey[700]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Share
                        GestureDetector(
                          onTap: () {
                            Share.share("${post["content"]}\n— ${post["source"]}\n(via MyIslam App)");
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            child: Icon(
                              Icons.share_outlined,
                              size: 17,
                              color: isDark ? Colors.white60 : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Expandable comments section
                  if (isExpanded) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.02) : const Color(0xFFF8FAFC),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(22),
                          bottomRight: Radius.circular(22),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Comment items
                          ...comments.map((c) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: AppColors.islamicIndigo.withOpacity(0.2),
                                    child: Text(
                                      (c["author"] as String)[0],
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.islamicIndigo),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isDark ? AppColors.darkCardBg : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            c["author"] as String,
                                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            c["text"] as String,
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          const SizedBox(height: 6),

                          // Comment input
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 38,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkCardBg : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _commentController,
                                    style: const TextStyle(fontSize: 12),
                                    decoration: InputDecoration(
                                      hintText: "Add your reflection...",
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? Colors.white38 : Colors.grey,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _addComment(index),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.activeNavPillGradient,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
